Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3LUK6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:58:18 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37128 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3LUK6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:58:17 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:58:10 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] drivers: bcm: Remove unused function in nvm.c
Message-ID: <20131221105810.GI3611@leaf>
References: <20131221103321.GA3332@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221103321.GA3332@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 04:03:22PM +0530, Rashika Kheria wrote:
> Remove unused function PropagateCalParamsFromEEPROMToMemory() in nvm.c.
> 
> This eliminates the following warning in nvm.c:
> drivers/staging/bcm/nvm.c:1369:5: warning: no previous prototype for ‘PropagateCalParamsFromEEPROMToMemory’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/bcm/nvm.c |   61 ---------------------------------------------
>  1 file changed, 61 deletions(-)
> 
> diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
> index 9e5f955..6f40f17 100644
> --- a/drivers/staging/bcm/nvm.c
> +++ b/drivers/staging/bcm/nvm.c
> @@ -1355,67 +1355,6 @@ BeceemFlashBulkWriteStatus_EXIT:
>  }
>  
>  /*
> - * Procedure:	PropagateCalParamsFromEEPROMToMemory
> - *
> - * Description: Dumps the calibration section of EEPROM to DDR.
> - *
> - * Arguments:
> - *		Adapter    - ptr to Adapter object instance
> - * Returns:
> - *		OSAL_STATUS_CODE
> - *
> - */
> -
> -int PropagateCalParamsFromEEPROMToMemory(struct bcm_mini_adapter *Adapter)
> -{
> -	PCHAR pBuff = kmalloc(BUFFER_4K, GFP_KERNEL);
> -	unsigned int uiEepromSize = 0;
> -	unsigned int uiIndex = 0;
> -	unsigned int uiBytesToCopy = 0;
> -	unsigned int uiCalStartAddr = EEPROM_CALPARAM_START;
> -	unsigned int uiMemoryLoc = EEPROM_CAL_DATA_INTERNAL_LOC;
> -	unsigned int value;
> -	int Status = 0;
> -
> -	if (!pBuff)
> -		return -ENOMEM;
> -
> -	if (0 != BeceemEEPROMBulkRead(Adapter, &uiEepromSize, EEPROM_SIZE_OFFSET, 4)) {
> -		kfree(pBuff);
> -		return -1;
> -	}
> -
> -	uiEepromSize >>= 16;
> -	if (uiEepromSize > 1024 * 1024) {
> -		kfree(pBuff);
> -		return -1;
> -	}
> -
> -	uiBytesToCopy = MIN(BUFFER_4K, uiEepromSize);
> -
> -	while (uiBytesToCopy) {
> -		if (0 != BeceemEEPROMBulkRead(Adapter, (PUINT)pBuff, uiCalStartAddr, uiBytesToCopy)) {
> -			Status = -1;
> -			break;
> -		}
> -		wrm(Adapter, uiMemoryLoc, (PCHAR)(((PULONG)pBuff) + uiIndex), uiBytesToCopy);
> -		uiMemoryLoc += uiBytesToCopy;
> -		uiEepromSize -= uiBytesToCopy;
> -		uiCalStartAddr += uiBytesToCopy;
> -		uiIndex += uiBytesToCopy / 4;
> -		uiBytesToCopy = MIN(BUFFER_4K, uiEepromSize);
> -
> -	}
> -	value = 0xbeadbead;
> -	wrmalt(Adapter, EEPROM_CAL_DATA_INTERNAL_LOC - 4, &value, sizeof(value));
> -	value = 0xbeadbead;
> -	wrmalt(Adapter, EEPROM_CAL_DATA_INTERNAL_LOC - 8, &value, sizeof(value));
> -	kfree(pBuff);
> -
> -	return Status;
> -}
> -
> -/*
>   * Procedure:	PropagateCalParamsFromFlashToMemory
>   *
>   * Description: Dumps the calibration section of EEPROM to DDR.
> -- 
> 1.7.9.5
> 
