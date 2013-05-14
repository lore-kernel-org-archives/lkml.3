Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3ENLGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:06:31 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:47763 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3ENLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130514092614.GH3297@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdY8SLRR0HQvD5AFUeNeeHRVt3XM-MOkwJs_h_EfeRctKw@mail.gmail.com>
	<20130514092614.GH3297@gmail.com>
Date: Tue, 14 May 2013 13:06:29 +0200
Message-ID: <CACRpkdaiZNeh9u_e7wSkHPmrxfaFQLeQEpZXEV4f+rXCCpW_eg@mail.gmail.com>
Subject: Re: [PATCH 9/9] mfd: ab8500-core: Pass GPADC compatible string to MFD core
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:26 AM, Lee Jones <lee.jones@linaro.org> wrote:

>> probing and does not have an .of_match_table defined in it's
>> driver struct? I mean, what could possibly match that
>> compatible string? The .name field will take care of naming
>> the device does it not?
>
> You only need that stuff if you require _extra_ bindings. Things like
> regulators and interrupt numbers are configured behind the scenes.

Sure, but isn't the idea with of_match_table that this should be
used in drivers when probing from device tree?

Surely it *works* with other schemes but I always thought about
them as some kind of rough fallback hacks. I would be way more
convenient with the patch if it added an of_match_table to
the ADC driver as well, because then I understand what is
going on.

>> For non-emergency merging though:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> If we don't put this into v3.10-rcX, then the GPADC driver will be
> broken in v3.10 when booting with DT.

OK I think I understand why now...

>> But for this to make sense the AB8500 ADC driver needs
>> to be augmented for DT probing and preferrably also moved
>> to drivers/adc and made to utilize that subsystem.
>
> Not sure I understand the reasoning for this. It works well as a plain
> MFD device.

The commit message says:
 "Without it, the driver won't be able to interrogate the Device Tree or
  locate suitable regulators and will most likely fail to probe."

That commit message makes it sound like the driver is
interrogating (hm is that the right term...) the device tree, but
now you say it isn't (as you say it is a plain MFD device).
Of course the MFD core and drivers/of/platform.c is doing
all sorts of magic based on the device tree, and that is
what the patch fixes, right? Nothing to do with the driver
really?

I suspect the missing regulators due to how the OF core or
MFD core uses the device tree is the actual problem
solved by the patch?

Anyway I think I was after this:

Isn't the idea that all devices that get probed from a device tree
shall have corresponding bindings documented under
Documentation/devicetree/bindings/*?

And this driver is definately in the wrong subsystem (not your
fault) so I suspect the binding doc should be in
Documentation/devicetree/bindings/adc/ab8500.txt or
something. I'm not pointing that out as a problem in this
patch, I'm just discussing the mess we're in ...

Yours,
Linus Walleij
