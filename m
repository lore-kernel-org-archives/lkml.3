Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3G2T72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:59:28 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56924 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3G2T71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:59:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: balbi@ti.com
Cc: Illia Smyrnov <illia.smyrnov@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for keypad.
Date: Mon, 29 Jul 2013 12:59:23 -0700
Message-ID: <2416808.ThTjdiEasK@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.5 (Linux/3.9.9-201.fc18.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130729191324.GA5767@radagast>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com> <7605900.g1IUvSbegi@dtor-d630.eng.vmware.com> <20130729191324.GA5767@radagast>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 10:13:24 PM Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jul 29, 2013 at 11:59:45AM -0700, Dmitry Torokhov wrote:
> > > > @@ -439,12 +444,50 @@ static const struct of_device_id
> > > > omap_keypad_dt_match[] = {>
> > > > 
> > > >  MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> > > >  #endif
> > > > 
> > > > +#ifdef CONFIG_PM_SLEEP
> > > > +static int omap4_keypad_suspend(struct device *dev)
> > > > +{
> > > > +	struct platform_device *pdev = to_platform_device(dev);
> > > 
> > > you don't need to access the platform_device...
> > > 
> > > > +	struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
> > > 
> > > ... since this can become:
> > > 	struct omap4_keypad *keypad_data = dev_get_drvdata(dev);
> > 
> > No, please use correct accessors for the objects. Platform drivers deal
> > with platform devices and I prefer using platform_get_drvdata() on them.
> 
> The argument to this function is a struct device, you prefer to do some
> pointer math to find the containing pdev, then deref that back to dev,
> then to struct device_private and further to driver_data ?
> 
> Sounds like a waste of time IMHO. You already have the device pointer
> anyway, why would you go through the trouble of calculating the
> offsets for the containing struct platform_device ?

This assumes knowledge of dev_get_drvdata() implementation and assumption
that it will stay the same. Unless I hear from device core guys that
<bus>_{get|set}_drvdata() methods are obsolete and will be eventually
removed I will require proper accessors being used.

Thanks!

-- 
Dmitry
