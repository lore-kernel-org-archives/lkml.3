Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaJGMzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:55:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:50477 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:55:50 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 7 Oct 2014 14:52:58 +0200
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Johan Hovold <johan@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/6] mfd: rtsx_usb: fix platform device-id collision
Message-ID: <20141007125258.GE5362@localhost>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
 <1411728933-13351-3-git-send-email-johan@kernel.org>
 <20141007092258.GR25331@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007092258.GR25331@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:22:58AM +0100, Lee Jones wrote:
> On Fri, 26 Sep 2014, Johan Hovold wrote:
> 
> > Hot-pluggable multi-function devices should use PLATFORM_DEVID_AUTO to
> > avoid name collisions on the platform bus.
> > 
> > This driver currently uses the USB-device address as an id. This makes
> > name collisions unlikely, but it could still happen if two devices are
> > connected to separate buses and gets assigned the same address.
> > 
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/mfd/rtsx_usb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This patch is superfluous.

Well, it would have documented the fact that there could be probe
failures due to id collisions with current and older kernels.

> Just wait until the hotpluggable version is applied, then use it.

Fine with me. The collisions are quite unlikely anyway.

Thanks,
Johan

> > diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> > index 71f387ce8cbd..78073e4b87e4 100644
> > --- a/drivers/mfd/rtsx_usb.c
> > +++ b/drivers/mfd/rtsx_usb.c
> > @@ -647,7 +647,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
> >  	/* initialize USB SG transfer timer */
> >  	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
> >  
> > -	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
> > +	ret = mfd_add_devices(&intf->dev, PLATFORM_DEVID_AUTO, rtsx_usb_cells,
> >  			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
> >  	if (ret)
> >  		goto out_init_fail;
