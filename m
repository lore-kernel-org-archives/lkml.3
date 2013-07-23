Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3GWPzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:55:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52164 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:55:14 -0400
Message-ID: <51EEA75E.3050008@wwwdotorg.org>
Date: Tue, 23 Jul 2013 08:55:10 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Jon Loeliger <jdl@jdl.com>, "Chaiken, Alison" <Alison_Chaiken@mentor.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <1925583.R0td2pS6as@flatron> <E1V1Nkn-00072x-Df@jdl.com> <1687020.5ErE9ecltl@flatron>
In-Reply-To: <1687020.5ErE9ecltl@flatron>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 02:57 PM, Tomasz Figa wrote:
> On Monday 22 of July 2013 16:34:49 Jon Loeliger wrote:

>>> My idea is to implement compile time verification in dtc, so I guess it
>>> will be more like the latter. Since dts is what dtc can already parse,
>>> my plan is to keep the schemas in spirit to dts, just
>>> modifying/extending it to allow specifying bindings with them, rather
>>> than static values.

> Things start to become fun when you get to bindings like regulators or 
> clocks, when part of the binding is defined on generic level (-supply, 
> clocks, clock-names properties) and remaining part is specific to device 
> (XXX in XXX-supply, count and order of clocks and clock-names, strings 
> allowed in clock-names property). This kind of inheritance is likely to be 
> the biggest troublemaker.

It's good you mentioned inheritance here. I believe that's one of the
key things. For example, the Tegra GPIO controller's binding is-a
GPIO-controller, and is-an interrupt-controller, and I imagine any
successful DT schema definition would very explicitly include that
information. Likewise, other nodes may be is-a GPIO-client (many times,
each parameterized with the property name that defines which GPIO you're
talking abot), and also may be is-an interrupt-client (with a similar
comment), etc.

