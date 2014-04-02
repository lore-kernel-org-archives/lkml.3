Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbaDBJN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:13:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39816 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbaDBJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:13:54 -0400
Date: Wed, 2 Apr 2014 12:13:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: m.chehab@samsung.com, devel@driverdev.osuosl.org, bernat.ada@gmail.com,
        gregkh@linuxfoundation.org, jarod@wilsonet.com,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        mtrompou@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: lirc: fix NULL pointer dereference
Message-ID: <20140402091334.GV6991@mwanda>
References: <1671118.MbmRfxWPeo@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671118.MbmRfxWPeo@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 05:18:39PM +0900, Daeseok Youn wrote:
> 
> coccicheck says:
>  drivers/staging/media/lirc/lirc_igorplugusb.c:226:15-21:
> ERROR: ir is NULL but dereferenced.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_igorplugusb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
> index f508a13..0ef393b 100644
> --- a/drivers/staging/media/lirc/lirc_igorplugusb.c
> +++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
> @@ -223,8 +223,8 @@ static int unregister_from_lirc(struct igorplug *ir)
>  	int devnum;
>  
>  	if (!ir) {
> -		dev_err(&ir->usbdev->dev,
> -			"%s: called with NULL device struct!\n", __func__);
> +		printk(DRIVER_NAME "%s: called with NULL device struct!\n",
> +		       __func__);


It should be pr_err() or something.  But actually "ir" can't be NULL so
just delete the whole condition.


>  		return -EINVAL;
>  	}

regards,
dan carpenter

