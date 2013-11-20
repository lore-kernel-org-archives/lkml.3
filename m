Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3KTRTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:19:07 -0500
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:52851 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754257Ab3KTRTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:19:01 -0500
Date: Wed, 20 Nov 2013 18:20:23 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: boris brezillon <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek
 board
Message-ID: <20131120172023.GI14627@ns203013.ovh.net>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
 <1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>
 <20131120145926.GE14627@ns203013.ovh.net>
 <528CDFFB.1020601@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CDFFB.1020601@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 17206283851779976057
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:14 Wed 20 Nov     , boris brezillon wrote:
> On 20/11/2013 15:59, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >On 13:06 Wed 28 Aug     , Boris BREZILLON wrote:
> >>Add slot0 of mmc0 pinctrl pins definitions:
> >>  - detect pin
> >>  - write protect pin
> >>  - enable slot0 pin: this pin is connected to an external switch which
> >>    enable mmc0 slot0 or spi dataflash connected to cs3
> >>
> >>The mmc0 device is not enabled, as it depends on the choosen functionnality
> >>(spi cs3 or mmc0 slot0).
> >>
> >>Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> >>---
> >>  arch/arm/boot/dts/at91rm9200ek.dts |   35 +++++++++++++++++++++++++++++++++++
> >>  1 file changed, 35 insertions(+)
> >>
> >>diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
> >>index f2d6d79..2bad423 100644
> >>--- a/arch/arm/boot/dts/at91rm9200ek.dts
> >>+++ b/arch/arm/boot/dts/at91rm9200ek.dts
> >>@@ -39,6 +39,23 @@
> >>  						atmel,pins = <AT91_PIOD 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;
> >>  					};
> >>  				};
> >>+
> >>+				mmc0 {
> >>+					pinctrl_mmc0_slot0_detect: mmc0_slot0_detect-0 {
> >>+						atmel,pins =
> >>+							<AT91_PIOB 27 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> >>+					};
> >>+
> >>+					pinctrl_mmc0_slot0_write_protect: mmc0_slot0_write_protect-0 {
> >>+						atmel,pins =
> >>+							<AT91_PIOA 17 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
> >>+					};
> >>+
> >>+					pinctrl_mmc0_slot0_switch: mmc0_slot0_switch-0 {
> >>+						atmel,pins =
> >>+							<AT91_PIOB 22 AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
> >>+					};
> >nack this is a regulator the pinctrl API is not done for gpio default value
> 
> I know this can be represented as a regulator, but looking at the
> datasheet, this looks more
> like a switch than a regulator.

so you load the dt via user space and use the regulator NOT the pinctrl

I do not want to see gpio control via pinctrl as we have no tracability of it
in gpio lib what so ever

> 
> Anyway, why didn't you told me that when I proposed the OUTPUT
> support for at91 pinctrl driver ?

you never get my Ack for this and I'm the pinctrl-at91 maintainer

so NACK

Best Regards,
J.
