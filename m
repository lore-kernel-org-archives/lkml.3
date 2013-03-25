Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab3CYTRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:17:36 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46554 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab3CYTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:17:35 -0400
Date: Mon, 25 Mar 2013 12:17:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick =?iso-8859-1?Q?=D8stergaard?= <oe.nick@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: prism2usb.c: fix printk(KERN_ERR... to
 pr_err(...
Message-ID: <20130325191732.GA22609@kroah.com>
References: <1364238148-22329-1-git-send-email-oe.nick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364238148-22329-1-git-send-email-oe.nick@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 08:02:28PM +0100, Nick Østergaard wrote:
> Fixed checkpatch.pl warning, changing fix printk(KERN_ERR... to
> pr_err(...
> 
> Signed-off-by: Nick Østergaard <oe.nick@gmail.com>
> ---
>  drivers/staging/wlan-ng/prism2usb.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
> index b1aed1f..0f2706a 100644
> --- a/drivers/staging/wlan-ng/prism2usb.c
> +++ b/drivers/staging/wlan-ng/prism2usb.c
> @@ -113,14 +113,14 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
>  	dev = interface_to_usbdev(interface);
>  	wlandev = create_wlan();
>  	if (wlandev == NULL) {
> -		printk(KERN_ERR "%s: Memory allocation failure.\n", dev_info);
> +		pr_err("%s: Memory allocation failure.\n", dev_info);

Please use dev_err() instead, as you do have a valid struct device in
which to use.

thanks,

greg k-h
