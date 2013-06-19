Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab3FSMiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:38:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSMh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:37:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
Date: Wed, 19 Jun 2013 14:37:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pawel Moll <pawel.moll@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com> <1371547782.16725.11.camel@hornet> <20130619093014.GX7161@zurbaran>
In-Reply-To: <20130619093014.GX7161@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191437.20759.arnd@arndb.de>
X-Provags-ID: V02:K0:o63ayR7hH1zZlPkPD+sjdH9eDR5+/OSpHUar0Rye76J
 j5Pr4BaPjw09cf7Nn1ax1YoD8k48gxMNwadFvGwG5igtPIui5R
 4+aZ6pG++UpVcIoeECTCTPijZ2sP72XGm2nnyo6hBCqAGh3+BA
 0Zj38M8ckUbhBrEl8Mv263xlg9jkjCCh4NRaJeTuspl3msPYzn
 L0IcCc4XU1WzUoNp4EHmwPVHbpXTtd4NzkCHK2IVJltiQcuhah
 x39O+ug1V5pD6wYUnEXbIs8a6utaGLJ4jvzyiys5Tp5L8CehXY
 4c6sm+SRx70pb9o6mBAcswAFXF84PUf+eKzKFXAMIuX8ikwPSK
 rRW8w+4pWjLhaXPjVj8M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Samuel Ortiz wrote:
> > 2. Move the vexpress-sysreg "platform management" functions into misc
> > (unless we get any better place for it)
> This is for Arnd and Greg to decide I suppose.


I think when vexpress-sysreg was created, we didn't have the syscon driver
yet, otherwise I think we should have used that, and put separate
drivers on top.

Not sure if it's too late for changing it to that now, given that
we already have a binding.

It seems we should use the same code for versatile and realview, or
at least it will only need small modifications to apply to all of
these platforms.

What I think could be helpful here is:

* export a "syscon" for the low-level registers

* add a gpio driver based on the syscon interface, and move the gpiochip
  implementation there

* move the low-leve "config" code from the sysreg driver into the
  vexpress-config driver and make it use the syscon.

* move the other global functions from the driver into the callers
  and use syscon there.

That would end up eliminating the sysreg driver, aside from maybe
a one-line change to the syscon driver to allow it to probe the
right device.

> > 3. Move vexpress-config into drivers/bus as it is (however I see no one
> > in MAINTAINERS for this directory)
> ISTR that Arnd originally created that directory, so he may help here.
> Arnd also had some concerns about implementing this code as a bus,
> mostly about it not being a discoverable bus. IMHO that's a valid
> concern, and this is why you ended up putting it under MFD which can be
> seen as some sort of platform devices bus. But I still believe the bus
> API would make this code look cleaner and easier to maintain.

Sorry, I don't see why it would be a bus. I assume that there is code
missing somewhere that is not yet merged, right?

	Arnd
