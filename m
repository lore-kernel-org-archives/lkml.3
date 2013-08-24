Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3HXVeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:34:06 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:46045 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755718Ab3HXVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:34:04 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 0/3] pinctrl: at91: add support for generic pinconf
Date: Sat, 24 Aug 2013 23:32:06 +0200
Message-Id: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 2790261445335873760
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is an attempt to add support for generic pin config
syntax to at91 pinctrl driver.

My primary goal is to add support for output configuration from dt definition.
This is needed to fully move at91rm9200ek board to dt (other boards may have
the same needs).
This board use a pin to drive an external switch which select between 2
functionnalities:
 - mmc interface
 - spi interface
The pin level is currently configured in the board init (init_machine) function
based on user config choices (CONFIG_MTD_AT91_DATAFLASH_CARD).

Instead of adding a new flag to the current (native) pin config binding, I
tried to add support for the generic pin config used by some pinctrl drivers
(i.e. rockchip).

Is this the right way to do this or should I add a new at91 native flags for
output config (OUTPUT_HIGH/LOW) ?

The second patch introduce a new config parameter to add a glitch filter on a
specific pin.
Glitch filter is similar to bounce filter (or debounce) but with a smaller
delay (expressed in nsecs ?).

I'm not sure this is the right approach.
Maybe we should reuse the debounce parameter and add a flag to specify the delay
unit (usec or nsec).

What do you think ?

The third patch migrate sama5 dt boards to the new generic config syntax.

Please feel free to share your thoughts.

Best Regards,

Boris


Boris BREZILLON (3):
  pinctrl: add new generic pinconf config for deglitch filter
  pinctrl: at91: add support for generic pinconf
  ARM: at91/dt: move sama5 to generic pinconf

 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |   43 ++-
 .../bindings/pinctrl/pinctrl-bindings.txt          |    1 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  363 ++++++++++----------
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |    2 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |   12 +-
 drivers/pinctrl/Kconfig                            |    2 +-
 drivers/pinctrl/pinconf-generic.c                  |    2 +
 drivers/pinctrl/pinctrl-at91.c                     |  265 +++++++++++++-
 include/linux/pinctrl/pinconf-generic.h            |    5 +
 9 files changed, 494 insertions(+), 201 deletions(-)

-- 
1.7.9.5

