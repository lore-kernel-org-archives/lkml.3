Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbbAZMaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:30:16 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35227 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbbAZMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:30:12 -0500
Date: Mon, 26 Jan 2015 14:30:04 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        thomas@grouk.net, tapaswenipathak@gmail.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org,
        sudipm.mukherjee@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150126123004.GA7895@mohammed-Inspiron-3537>
References: <20150124202053.GA1641@mohammed-Inspiron-3537>
 <20150125115755.GA1369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150125115755.GA1369@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 07:57:55PM +0800, Greg KH wrote:
> On Sat, Jan 24, 2015 at 10:20:53PM +0200, Heba Aamer wrote:
> > This patch fixes the following checkpatch.pl warning:
> > fix Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then
> > dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> > 
> > netdev_info was used since it is a network subsystem
> > 
> > Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
> > ---
> >  drivers/staging/rtl8712/usb_intf.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
> > index 7d0d171..7748a75 100644
> > --- a/drivers/staging/rtl8712/usb_intf.c
> > +++ b/drivers/staging/rtl8712/usb_intf.c
> > @@ -366,7 +366,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
> >  	struct net_device *pnetdev;
> >  	struct usb_device *udev;
> >  
> > -	printk(KERN_INFO "r8712u: Staging version\n");
> > +	netdev_info(pnetdev, "r8712u: Staging version\n");
> >  	/* In this probe function, O.S. will provide the usb interface pointer
> >  	 * to driver. We have to increase the reference count of the usb device
> >  	 * structure by using the usb_get_dev function.
> 
> Please don't send patches that you do not at least test-build, it's a
> bit rude and wastes people's time.
>

Sorry Greg! I did build the module but it was cached. I built the 
driver again after cleaning it, and I did find a warning related to 
my patch. I had a question though, I found a warning related to an
unused function. Here is the warning:

drivers/staging/rtl8712/rtl871x_mp_ioctl.c:708:12: warning: 
‘mp_query_drv_var’ defined but not used [-Wunused-function]

Should I remove this function or should I keep it as is?
If it will be removed, I will send it in a different patch. 
 
> Oh, and also ensure that your patch is correct, hint, this one does not
> work at all :(

Sorry again and I will be sending the new patch soon.

> 
> greg k-h

Heba Aamer
