Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090Ab3IDQgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:36:01 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43468 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763120Ab3IDQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:33:09 -0400
Date: Wed, 4 Sep 2013 17:33:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>, wsa@the-dreams.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Documentation: dt: i2c: Add LPS001WP to the Trivial
 Devices list
Message-ID: <20130904163303.GC8980@lee--X1>
References: <1378302655-13258-1-git-send-email-lee.jones@linaro.org>
 <20130904142422.GM18206@e106331-lin.cambridge.arm.com>
 <20130904151159.GA8980@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130904151159.GA8980@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looping Wolfram back in, as I cocked up his email address.

> Cheers for producing a binding.
> 
> On Wed, Sep 04, 2013 at 02:50:55PM +0100, Lee Jones wrote:
> > LPS001WP is a Pressure and Temperature sensor.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > index ad6a738..6038807e6 100644
> > --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > @@ -57,6 +57,7 @@ st-micro,24c256		i2c serial eeprom  (24cxx)
> >  stm,m41t00		Serial Access TIMEKEEPER
> >  stm,m41t62		Serial real-time clock (RTC) with alarm
> >  stm,m41t80		M41T80 - SERIAL ACCESS RTC WITH ALARMS
> > +stm,lps001wp		Pressure and Temperature sensor
> 
> As I hinted at in the other thread [1], I don't think this can be
> documented as a trivial binding -- the driver expects a couple of
> regulators which should be described in the binding (or the driver
> shouldn't be using them...).

Surely all devices need to be powered and would subsequently require a
regulator of one description or other? We don't really *need* to
manually enable it on my platform but that's because it's 'always
on', but we do anyway for completeness.

Would a (regulator: vdd) note in this patch be suitable? It seems a
shame to have to produce a boilerplate binding entry for the sake of a
regulator.

Wolfram, what's the common procedure in cases such as these?

> Also, in the other thread the "st," prefix was used [2], while "stm," is
> listed at the prefix in the binding. As far as I can see, "st," should
> be used, as it's in vendor-prefixes and "stm," is not.
> 
> I'm happy to cook up a patch adding deprecation notes and corrected
> strings for the existing incorrect "stm," bindings.

Sure, feel free.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
