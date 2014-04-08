Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaDHSwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:52:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56608 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841AbaDHSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <CANk1AXR0bDENDV673M-AVXNWHmGuee5SGc+ZnPqdBdEBwJXQXQ@mail.gmail.com>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	<1396907649-20212-2-git-send-email-tthayer@altera.com>
	<20140408133818.GB16054@pengutronix.de>
	<1396967390.23349.15.camel@dinh-ubuntu>
	<20140408143327.GC16054@pengutronix.de>
	<CANk1AXR0bDENDV673M-AVXNWHmGuee5SGc+ZnPqdBdEBwJXQXQ@mail.gmail.com>
Date: Tue, 8 Apr 2014 13:52:31 -0500
Message-ID: <CAL_JsqJRweynpCA7LMFU4wfa71XzjGC3b8H9XKJpogf5H93h_A@mail.gmail.com>
Subject: Re: [PATCH 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
From: Rob Herring <robherring2@gmail.com>
To: delicious quinoa <delicious.quinoa@gmail.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Thor Thayer <tthayer@altera.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 11:02 AM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:
> On Tue, Apr 8, 2014 at 9:33 AM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
>> On Tue, Apr 08, 2014 at 09:29:50AM -0500, Thor Thayer wrote:
>>> On Tue, 2014-04-08 at 15:38 +0200, Steffen Trumtrar wrote:
>>> > Hi!
>>> >
>>> > On Mon, Apr 07, 2014 at 04:54:07PM -0500, tthayer@altera.com wrote:
>>> > > From: Thor Thayer <tthayer@altera.com>
>>> > >
>>> > > Addition of the Altera SDRAM controller bindings and device
>>> > > tree changes to the Altera SoC project.
>>> > >
>>> [snip]
>>> > > +
>>> > > +Required properties:
>>> > > +- compatible : "altr,sdr-ctl", "syscon";
>>> > > +                Note that syscon is invoked for this device to support the FPGA
>>> > > +         bridge driver, EDAC driver and other devices that share the
>>> > > +         registers.
>>> > > +- reg : Should contain 1 register ranges(address and length)
>>> >
>>> > I haven't really thought this through, but why would the FPGA bridge driver
>>> > access the sdram controller? For releasing the resets in fpgaportrst ? Or is
>>> > there more?
>>>
>>> Hi Steffan. No, not for resets. We need to enable the FPGA to SDRAM
>>> path. Our SDRAM controller allows FPGA master access to the SDRAM.
>>>
>>
>> Yes. But what you have to do to enable the path is let the FPGA port you use
>> out of reset. And that is it as far as I can see. The rest happens in the
>> bitstream. Or is there more to enable the path?
>> The FPGA2SDRAM bridge is the one I didn't use as of yet, so if I miss something
>> please elaborate.
>
> Hi Steffen,
>
> The sdram controller is used by two drivers.  That's why we want to
> specify "syscon" here.  The other driver is the FPGA bridge driver.
> Its functionality is very separate from what this driver is doing (we
> are not enabling the bridge in this driver; we are enabling the
> monitoring and resetting the interrupt bit of the EDAC).  We wanted to
> specify "syscon" her so that we don't have to have to change it for
> the other driver.

But are there actually overlapping registers which are accessed by
both drivers and need the protection of regmap?

Perhaps MFD is more appropriate than syscon?

Rob
