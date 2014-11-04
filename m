Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaKDJKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:10:30 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41877 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDJK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:10:26 -0500
Date: Tue, 4 Nov 2014 09:10:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_sch: don't call mfd_remove_devices()
Message-ID: <20141104091021.GH17577@x1>
References: <1415035763-24277-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415035763-24277-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Andy Shevchenko wrote:

> MFD core already cares about failing registration. It will remove successfully
> registered devices in case of error. Thus, no need to repeatedly call
> mfd_remove_devices().
> 
> Fixes: 5829e9b64e65 (mfd: lpc_sch: Accomodate partial population of the MFD devices)
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index c980da4..5c38df3 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -193,11 +193,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  		return -ENODEV;
>  	}
>  
> -	ret = mfd_add_devices(&dev->dev, 0, lpc_sch_cells, cells, NULL, 0, NULL);
> -	if (ret)
> -		mfd_remove_devices(&dev->dev);
> -
> -	return ret;
> +	return mfd_add_devices(&dev->dev, 0, lpc_sch_cells, cells, NULL, 0, NULL);
>  }
>  
>  static void lpc_sch_remove(struct pci_dev *dev)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
