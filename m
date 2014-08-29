Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaH2LXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:23:34 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39777 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaH2LXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:23:32 -0400
Date: Fri, 29 Aug 2014 12:23:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd: imanager2: Add Core supports for IT8516/18/28
Message-ID: <20140829112326.GL24579@lee--X1>
References: <1408442679-3662-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408442679-3662-1-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Wei-Chun Pan wrote:

> > You've replied to this email as an independent message, so now there is little
> > context.  When you reply, please ensure your mailer replies to the thread.
> > 
> 
> Could you tell me more detail about this?
> I use Git to reply mails but don't know how to set them to be dependent on.

How do you use Git to reply to emails?

> > On Thu, 07 Aug 2014, Wei-Chun Pan wrote:
> > > I have a question for your comment. As your mail,
> > >
> > > > > +
> > > > > +static void __exit imanager2_mfd_device_exit(void) {
> > > > > +	mfd_remove_devices(&ec_pdev->dev);
> > > > > +	platform_device_unregister(ec_pdev);
> > > > > +}
> > > > > +
> > > > > +module_init(imanager2_mfd_device_init);
> > > > > +module_exit(imanager2_mfd_device_exit);
> > > >
> > > > This is a mess.  Use module_platform_driver() instead.
> > > >
> > > > > +MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at
> > > > > +advantech.com>");
> > > > > +MODULE_DESCRIPTION("iManager2 platform device definitions v"
> > > > > +DRV_VERSION); MODULE_LICENSE("GPL");
> > MODULE_VERSION(DRV_VERSION);
> > > >
> > >
> > > How can I use module_platform_driver() and my driver exit function
> > > also can do mfd_remove_devices().
> > > Or any other better function install of mfd_remove_devices()?
> > 
> > That's the point - you don't do mfd_remove_devices() in exit(), you do
> > mfd_add_devices() in .probe() and mfd_remove_devices() in .remove().
> > 
> > The only thing you want to do in init() is platform_driver_register(), or even better
> > - don't have init() and exit() calls and use use
> > module_platform_driver_probe() instead.
> > 
> 
> It seems that module_platform_driver() only registers/unregisters driver but not device.
> Is there a method to register/unregister my device?

You need to do that from Device Tree or from within arch/<arch>/{mach,plat}-*

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
