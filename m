Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935754Ab3IELan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:30:43 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54688 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935586Ab3IELal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:30:41 -0400
Date: Thu, 5 Sep 2013 12:30:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "sa@the-dreams.de" <sa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: Re: [PATCH] Documentation: dt: i2c: Add LPS001WP to the Trivial
 Devices list
Message-ID: <20130905113001.GR18206@e106331-lin.cambridge.arm.com>
References: <1378302655-13258-1-git-send-email-lee.jones@linaro.org>
 <20130904142422.GM18206@e106331-lin.cambridge.arm.com>
 <20130904151159.GA8980@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904151159.GA8980@lee--X1>
Thread-Topic: [PATCH] Documentation: dt: i2c: Add LPS001WP to the Trivial
 Devices list
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:11:59PM +0100, Lee Jones wrote:
> > Cheers for producing a binding.
> > 
> > On Wed, Sep 04, 2013 at 02:50:55PM +0100, Lee Jones wrote:
> > > LPS001WP is a Pressure and Temperature sensor.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > index ad6a738..6038807e6 100644
> > > --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > @@ -57,6 +57,7 @@ st-micro,24c256		i2c serial eeprom  (24cxx)
> > >  stm,m41t00		Serial Access TIMEKEEPER
> > >  stm,m41t62		Serial real-time clock (RTC) with alarm
> > >  stm,m41t80		M41T80 - SERIAL ACCESS RTC WITH ALARMS
> > > +stm,lps001wp		Pressure and Temperature sensor
> > 
> > As I hinted at in the other thread [1], I don't think this can be
> > documented as a trivial binding -- the driver expects a couple of
> > regulators which should be described in the binding (or the driver
> > shouldn't be using them...).
> 
> Surely all devices need to be powered and would subsequently require a
> regulator of one description or other? We don't really *need* to
> manually enable it on my platform but that's because it's 'always
> on', but we do anyway for completeness.

They may or may not, that's a grey area. Regardless of whether you
actually need it, the driver is currently looking for two undocumented
entries in the DT. If you want to be able to use them, they must be
documented so that people know they exist, what format they are expected
to be, and what they actually represent.

We should not allow for undocumented ABIs.

> 
> Would a (regulator: vdd) note in this patch be suitable? It seems a
> shame to have to produce a boilerplate binding entry for the sake of a
> regulator.

I thought this could have two regulators (vdd and vms)? 

I also note that the device can also be attached to SPI. Do we have any
other devices which may be attached to either? Do we handle that, and if
so, how (do we have the same compatible string for both interfaces?)?

Thanks,
Mark.
