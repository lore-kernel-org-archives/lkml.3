Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaJGJXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:23:08 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46195 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaJGJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:23:04 -0400
Date: Tue, 7 Oct 2014 10:22:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/6] mfd: rtsx_usb: fix platform device-id collision
Message-ID: <20141007092258.GR25331@lee--X1>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
 <1411728933-13351-3-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411728933-13351-3-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Johan Hovold wrote:

> Hot-pluggable multi-function devices should use PLATFORM_DEVID_AUTO to
> avoid name collisions on the platform bus.
> 
> This driver currently uses the USB-device address as an id. This makes
> name collisions unlikely, but it could still happen if two devices are
> connected to separate buses and gets assigned the same address.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/mfd/rtsx_usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch is superfluous.

Just wait until the hotpluggable version is applied, then use it.

> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> index 71f387ce8cbd..78073e4b87e4 100644
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -647,7 +647,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
>  	/* initialize USB SG transfer timer */
>  	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
>  
> -	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
> +	ret = mfd_add_devices(&intf->dev, PLATFORM_DEVID_AUTO, rtsx_usb_cells,
>  			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
>  	if (ret)
>  		goto out_init_fail;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
