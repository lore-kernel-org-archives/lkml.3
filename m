Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3AYPXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:23:08 -0500
Received: from xes-mad.com ([216.165.139.218]:53945 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab3AYPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:23:06 -0500
Date: Fri, 25 Jan 2013 09:22:54 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
Message-ID: <b1a97ba8-e8d4-4421-8d7c-633ecdfa318a@zimbra>
In-Reply-To: <1359121338.883.8.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC20 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2013-01-25 at 14:25 +0100, Paul Bolle wrote:
> > 0) insmod-ing an updated lpc_ich.ko generated quite a bit of noise
> > in
> > dmesg:
> >     <6>[19913.247530] iTCO_wdt: Found a ICH8M-E TCO device
> >     (Version=2, TCOBASE=0x1060)
> >     <6>[19913.249310] iTCO_wdt: initialized. heartbeat=30 sec
> >     (nowayout=0)
> >     <4>[19913.249332] ACPI Warning:
> >     0x0000000000001028-0x000000000000102f SystemIO conflicts with
> >     Region \_SB_.PCI0.LPC_.PMIO 1 (20120913/utaddress-251)
> >     <6>[19913.249338] ACPI: If an ACPI driver is available for this
> >     device, you should use it instead of the native driver
> >     <4>[19913.249342] ACPI Warning:
> >     0x00000000000011b0-0x00000000000011bf SystemIO conflicts with
> >     Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
> >     <6>[19913.249347] ACPI: If an ACPI driver is available for this
> >     device, you should use it instead of the native driver
> >     <4>[19913.249349] ACPI Warning:
> >     0x0000000000001180-0x00000000000011af SystemIO conflicts with
> >     Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
> >     <6>[19913.249353] ACPI: If an ACPI driver is available for this
> >     device, you should use it instead of the native driver
> >     <4>[19913.249355] lpc_ich: Resource conflict(s) found affecting
> >     gpio_ich
> > 
> > I have no idea whatsoever what that could mean.
> 
> But please note that these messages are nothing new. I found
> identical
> messages in all my logs (from v3.7.y kernels; I do not seem to have
> logs
> of older releases anymore).
> 
> 
> Paul Bolle

Paul,
My understanding of these warnings is that your BIOS defines regions
in its ACPI tables that coincide with regions we want to pass to
gpio-ich. Because the regions are defined in the ACPI tables Linux
assumes that they are actively being used by the BIOS and that they
shouldn't be used, unless you tell the kernel to globally ignore
ACPI resource conflicts.

Similar warnings used to also appear for the TCO watchdog regions until
that was determined to be a regression and the ACPI resource conflict
checks were removed by this patch:

commit 092369efbd6ef6b4a215741ce9f65446bf45beff
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Aug 16 15:50:10 2012 +0800

    mfd: lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver

    [trimmed]

    Actually the same check could be removed for the gpio-ich in lpc_ich.c,
    but I'm not sure if it will cause problems.

Like Feng, I also am not sure if removing the checks for GPIO would cause
problems, so the noise remains.

-Aaron S.
