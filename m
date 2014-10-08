Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaJHWk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:40:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaJHWkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:40:24 -0400
Date: Wed, 8 Oct 2014 15:40:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, mark.einon@gmail.com
Subject: Re: [PATCH] staging: bcm: remove unnecessary else statement
Message-ID: <20141008224023.GB9464@kroah.com>
References: <1412099940-4118-1-git-send-email-karthik.188@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412099940-4118-1-git-send-email-karthik.188@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:29:00PM +0530, Karthik Nayak wrote:
> Removed the else statement occurring after an if statement with a
> return value as per checkpatch warning.
> 
> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> ---
>  drivers/staging/bcm/InterfaceMisc.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
> index e5bcfec..1f31b8f 100644
> --- a/drivers/staging/bcm/InterfaceMisc.c
> +++ b/drivers/staging/bcm/InterfaceMisc.c
> @@ -102,12 +102,11 @@ int InterfaceWRM(struct bcm_interface_adapter *psIntfAdapter,
>  				DBG_LVL_ALL, "WRM failed status :%d", retval);
>  		psIntfAdapter->psAdapter->DeviceAccess = false;
>  		return retval;
> -	} else {
> -		psIntfAdapter->psAdapter->DeviceAccess = false;
> -		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, WRM,
> -				DBG_LVL_ALL, "WRM sent %d", retval);
> -		return STATUS_SUCCESS;
>  	}
> +	psIntfAdapter->psAdapter->DeviceAccess = false;
> +	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, WRM,
> +			DBG_LVL_ALL, "WRM sent %d", retval);
> +	return STATUS_SUCCESS;
>  }
>  
>  int BcmRDM(void *arg,
> -- 
> 2.1.0

This doesn't apply either, someone else must have done this change
already.
