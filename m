Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaGaQMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:12:21 -0400
Received: from 8.mo5.mail-out.ovh.net ([178.32.116.78]:48865 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412AbaGaQMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:12:18 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20140731155906.GH3214@piout.net>
Date: Fri, 1 Aug 2014 00:10:05 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Ji=C5=99=C3=AD_Prchal?= <jiri.prchal@aksignal.cz>,
        Nicolas FERRE <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, voice.shen@atmel.com,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C5B462AE-B1D2-4067-91EB-44FDF49D28FA@jcrosoft.com>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz> <20140728122103.GR9532@piout.net> <53D64ADA.1000102@aksignal.cz> <20140728223859.GA3214@piout.net> <20140729100017.31f0b1be@bbrezillon> <20140731155906.GH3214@piout.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
X-Mailer: Apple Mail (2.1878.6)
X-Ovh-Tracer-Id: 7689896364366605203
X-Ovh-Remote: 112.65.146.3 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrheefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrheefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31, 2014, at 11:59 PM, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> On 29/07/2014 at 10:00:17 +0200, Boris Brezillon wrote :
>> Hi Alexandre,
>> 
>>> While this solves the particular issue Jiří is seeing, this will not
>>> solve the case where PA14 (CS0) is not used by the spi driver at all. It
>>> will remained muxed as CS0 and toggle when the spi master needs to
>>> access CS0 until another driver muxes it to something else. I still
>>> believe we should explicitly ask pinctrl to mux them as gpios.

This is not the job of the kernel but to the bootloader
no the pinctrl binding is not here and will never be here the configure a pin as a GPIO or
to a specific state. This the job of the driver or the bootloader

>>> 
>> 
>> Do we really care about this case ?
>> After all, if a given pin needs a specific muxing during kernel boot
>> (i.e. a pin connected to a gpio-led that needs to stay in its previous
>> state or a pin connected to the reset line of a device that needs to
>> stay up and running during kernel boot) the bootloader/bootstrap should
>> have muxed this pin appropriately before booting the kernel.
>> 
> 
> Yeah, you are right.
> 
> 
>> What do you mean by "we should explicitly ask pinctrl to mux them as
>> gpios" ?
>> Do you mean configuring all the pins as GPIOs when the pin controller is
>> probed, or just adding a new pinctrl state configuring the pin as an
>> output GPIO and reference it in the pinctrl-0 property of the spi
>> controller.
>> 
>> If the former, you'll break devices that needs their pins to stay in
>> the state they were during the bootloader/boostrap phase.
>> The latter won't work if the pin you request as GPIO is later requested
>> by another device (which, if I'm correct, is exactly the case you're
>> trying to solve).
>> 
> 
> Again you are right, let's not care about that use case. I still feel
> that the pinctrl-0 property has to be filled correctly.
> 
> -- 
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

