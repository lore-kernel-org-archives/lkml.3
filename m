Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3ENLef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:34:35 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45653 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3ENLee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:34:34 -0400
Date: Tue, 14 May 2013 12:34:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 9/9] mfd: ab8500-core: Pass GPADC compatible string to
 MFD core
Message-ID: <20130514113426.GB28781@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
 <1368019749-19455-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdY8SLRR0HQvD5AFUeNeeHRVt3XM-MOkwJs_h_EfeRctKw@mail.gmail.com>
 <20130514092614.GH3297@gmail.com>
 <CACRpkdaiZNeh9u_e7wSkHPmrxfaFQLeQEpZXEV4f+rXCCpW_eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaiZNeh9u_e7wSkHPmrxfaFQLeQEpZXEV4f+rXCCpW_eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> probing and does not have an .of_match_table defined in it's
> >> driver struct? I mean, what could possibly match that
> >> compatible string? The .name field will take care of naming
> >> the device does it not?
> >
> > You only need that stuff if you require _extra_ bindings. Things like
> > regulators and interrupt numbers are configured behind the scenes.
> 
> Sure, but isn't the idea with of_match_table that this should be
> used in drivers when probing from device tree?

We're not probing from Device Tree. We're registering from MFD.

> Surely it *works* with other schemes but I always thought about
> them as some kind of rough fallback hacks. I would be way more
> convenient with the patch if it added an of_match_table to
> the ADC driver as well, because then I understand what is
> going on.

They're not full-back hacks. All drivers obtain their interrupts this
way when using Device Tree.

> >> For non-emergency merging though:
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > If we don't put this into v3.10-rcX, then the GPADC driver will be
> > broken in v3.10 when booting with DT.
> 
> OK I think I understand why now...
> 
> >> But for this to make sense the AB8500 ADC driver needs
> >> to be augmented for DT probing and preferrably also moved
> >> to drivers/adc and made to utilize that subsystem.
> >
> > Not sure I understand the reasoning for this. It works well as a plain
> > MFD device.
> 
> The commit message says:
>  "Without it, the driver won't be able to interrogate the Device Tree or
>   locate suitable regulators and will most likely fail to probe."
> 
> That commit message makes it sound like the driver is
> interrogating (hm is that the right term...) the device tree, but
> now you say it isn't (as you say it is a plain MFD device).
> Of course the MFD core and drivers/of/platform.c is doing
> all sorts of magic based on the device tree, and that is
> what the patch fixes, right? Nothing to do with the driver
> really?

I guess you're kind of correct. Yes, it's not the actual driver that's
interrogating (yes it's the right term) the Device Tree, other
subsystems are doing it on the driver's behalf. But the driver's node
is being used, which is why we need the compatible string.

> I suspect the missing regulators due to how the OF core or
> MFD core uses the device tree is the actual problem
> solved by the patch?
> 
> Anyway I think I was after this:
> 
> Isn't the idea that all devices that get probed from a device tree
> shall have corresponding bindings documented under
> Documentation/devicetree/bindings/*?

It has an entry in  Documentation/devicetree/bindings/mfd/ab8500.txt.

> And this driver is definately in the wrong subsystem (not your
> fault) so I suspect the binding doc should be in
> Documentation/devicetree/bindings/adc/ab8500.txt or
> something.

All of the AB8500 devices are covered in the aforementioned file and
to my knowledge none of them are represented in their respective
'real' driver type's binding doc folders (except Power).

> I'm not pointing that out as a problem in this
> patch, I'm just discussing the mess we're in ...

Sure.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
