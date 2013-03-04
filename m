Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3CDRiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:38:13 -0500
Received: from [212.90.139.82] ([212.90.139.82]:37235 "EHLO smtp2.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab3CDRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:38:12 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.884
From: Lars Poeschel <poeschel@lemonage.de>
To: Rob Landley <rob@landley.net>
Subject: Re: [PATCH RFC] pwm: add sysfs interface
Date: Mon, 4 Mar 2013 18:38:14 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <1361664888.11282.16@driftwood>
In-Reply-To: <1361664888.11282.16@driftwood>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303041838.14792.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2013 at 01:14:48, Rob Landley wrote:
> On 02/19/2013 08:27:41 AM, Lars Poeschel wrote:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > This adds a simple sysfs interface to the pwm subsystem. It is
> > heavily inspired by the gpio sysfs interface.
> 
> Docs!

This means I have to add more information to the commit message ?
 
> > diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> > index 7d2b4c9..b349d16 100644
> > --- a/Documentation/pwm.txt
> > +++ b/Documentation/pwm.txt
> > @@ -45,6 +45,52 @@ int pwm_config(struct pwm_device *pwm, int
> > duty_ns, int period_ns);
> > 
> >  To start/stop toggling the PWM output use pwm_enable()/pwm_disable().
> 
> Hm, read read read existing file...
> 
> So a PWM is a GPIO that blinks on its own, in hardware, without needing
> a kernel thread and a timer to tell it to? (I think? Correction, an
> output-only gpio...)

You are right on that. I would add, that a PWM is working periodically and 
this period has an active portion (where the output is high) and an inactive 
one. You can choose, how long the active portion should last. The rest of the 
period is the inactive portion.

[snip]

> 
> Doc part looks good to me:
> 
> Acked-by Rob Landley <rob@landley.net>

Thanks!
 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index e513cd9..1c3432e 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -28,6 +28,21 @@ menuconfig PWM
> > 
> >  if PWM
> > 
> > +config PWM_SYSFS
> > +	bool "/sys/class/pwm/... (sysfs interface)"
> > +	depends on SYSFS
> > +	help
> > +	  Say Y here to add a sysfs interface for PWMs.
> > +
> > +	  This exports directories and files to userspace using sysfs.
> 
> Given that that's what a sysfs interface _is_, does that last line
> actually add anything?
> 
> > +	  This way the PWM outputs of a device can easyly be used,
> 
> s/easyly/easily/
> 
> > +	  controlled and tested.
> 
> And again, this sentence isn't hugely helpful if you already know what
> 
> sysfs is. Why not start here:
> > +	  For every instance of an PWM capable
> > +	  device there is a pwmchipX directory exported to
> > +	  /sys/class/pwm. If you want to use a PWM, you have to export
> > +	  it to sysfs, which is done by writing the number into
> > +	  /sys/class/pwm/export. After that /sys/class/pwm/pwmX is
> > +	  reaady to be used.
> > +
> 
> s/reaady/ready/

Thank you for your feedback!
I'll try to be a bit more descriptive in the Kconfig help.

Regards,
Lars
