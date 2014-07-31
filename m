Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaGaRYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:24:42 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:36815 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbaGaRYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:24:41 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20140731164836.GI3214@piout.net>
Date: Fri, 1 Aug 2014 01:05:24 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Ji=C5=99=C3=AD_Prchal?= <jiri.prchal@aksignal.cz>,
        Nicolas FERRE <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, voice.shen@atmel.com,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1EB953D9-8221-47A0-9025-0C39DD09B631@jcrosoft.com>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz> <20140728122103.GR9532@piout.net> <53D64ADA.1000102@aksignal.cz> <20140728223859.GA3214@piout.net> <20140729100017.31f0b1be@bbrezillon> <20140731155906.GH3214@piout.net> <C5B462AE-B1D2-4067-91EB-44FDF49D28FA@jcrosoft.com> <20140731164836.GI3214@piout.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
X-Mailer: Apple Mail (2.1878.6)
X-Ovh-Tracer-Id: 8602719714417027987
X-Ovh-Remote: 112.65.146.3 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2014, at 12:48 AM, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> 
> On 01/08/2014 at 00:10:05 +0800, Jean-Christophe PLAGNIOL-VILLARD wrote :
>>>>> While this solves the particular issue Jiří is seeing, this will not
>>>>> solve the case where PA14 (CS0) is not used by the spi driver at all. It
>>>>> will remained muxed as CS0 and toggle when the spi master needs to
>>>>> access CS0 until another driver muxes it to something else. I still
>>>>> believe we should explicitly ask pinctrl to mux them as gpios.
>> 
>> This is not the job of the kernel but to the bootloader
>> no the pinctrl binding is not here and will never be here the configure a pin as a GPIO or
> 
> This is exactly what AT91_PERIPH_GPIO does though. Anyway, not request
> the pinmuxing in the driver is not a good idea, then nothing prevents
> another driver to request them to do something completely different.

here it’s the same issue if you need to pin as GPIO use the GPIO API not the pinctrl

AT91_PERIPH_GPIO is use the set specific pinmux (bouncing & etc…)


> 
>> to a specific state. This the job of the driver or the bootloader
>> 
> 
> I agree that it must not allow to set the state, we are talking about
> muxing.
> 
> 
> -- 
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

