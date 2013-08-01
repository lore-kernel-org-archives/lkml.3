Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3HAHHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:07:00 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:53662 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756Ab3HAHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:06:59 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 0/8] ARM: at91/dt: make use of periph id macros 
Date: Thu,  1 Aug 2013 08:48:53 +0200
Message-Id: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 423056891267545196
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series move at91 SoCs peripheral id definitions from machine
specific include dir to dt-bindings include dir.
These macros are used to reference interrupts instead of peripheral numbers.

This makes dt definitions cleaner and easier to debug (one can easily tell if
the peripheral macro used to reference an interrupt line is not the good one).

These macros will be used for clk definitions and references too.

I am not sure 'include/dt-bindings/at91/xxx' is the best place to put these
definitions as there are no soc specific directories in dt-bindings include
dir right now. Maybe something like 'include/dt-bindings/soc/at91/xxx' or
'include/dt-bindings/peripherals/at91/xxx' would be better.
What do you think ?

Best Regards,

Boris

Boris BREZILLON (8):
  ARM: at91: move peripheral id definitions to dt-bindings include dir
  ARM: at91/dt: use periph id macros for at91rm9200 interrupt
    definitions
  ARM: at91/dt: use periph id macros for at91sam9260 interrupt
    definitions
  ARM: at91/dt: use periph id macros for at91sam9263 interrupt
    definitions
  ARM: at91/dt: use periph id macros for at91sam9g45 interrupt
    definitions
  ARM: at91/dt: use periph id macros for at91sam9n12 interrupt
    definitions
  ARM: at91/dt: use periph id macros for at91sam9x5 interrupt
    definitions
  ARM: at91/dt: use periph id macros for sama5d3 interrupt definitions

 arch/arm/boot/dts/at91rm9200.dtsi                  |   59 ++++++++------
 arch/arm/boot/dts/at91sam9260.dtsi                 |   57 +++++++-------
 arch/arm/boot/dts/at91sam9263.dtsi                 |   46 +++++------
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   57 +++++++-------
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   43 +++++-----
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   63 +++++++--------
 arch/arm/boot/dts/sama5d3.dtsi                     |   83 ++++++++++----------
 arch/arm/mach-at91/include/mach/at91rm9200.h       |   31 +-------
 arch/arm/mach-at91/include/mach/at91sam9260.h      |   29 +------
 arch/arm/mach-at91/include/mach/at91sam9261.h      |   23 +-----
 arch/arm/mach-at91/include/mach/at91sam9263.h      |   27 +------
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |   31 +-------
 arch/arm/mach-at91/include/mach/at91sam9n12.h      |   26 +-----
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |   25 +-----
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |   32 +-------
 arch/arm/mach-at91/include/mach/hardware.h         |    3 +-
 arch/arm/mach-at91/include/mach/sama5d3.h          |   48 +----------
 include/dt-bindings/at91/at91rm9200/peripherals.h  |   44 +++++++++++
 include/dt-bindings/at91/at91sam9260/peripherals.h |   42 ++++++++++
 include/dt-bindings/at91/at91sam9261/peripherals.h |   36 +++++++++
 include/dt-bindings/at91/at91sam9263/peripherals.h |   40 ++++++++++
 include/dt-bindings/at91/at91sam9g45/peripherals.h |   44 +++++++++++
 include/dt-bindings/at91/at91sam9n12/peripherals.h |   41 ++++++++++
 include/dt-bindings/at91/at91sam9rl/peripherals.h  |   38 +++++++++
 include/dt-bindings/at91/at91sam9x5/peripherals.h  |   45 +++++++++++
 include/dt-bindings/at91/common/peripherals.h      |   14 ++++
 include/dt-bindings/at91/sama5d3/peripherals.h     |   63 +++++++++++++++
 27 files changed, 629 insertions(+), 461 deletions(-)
 create mode 100644 include/dt-bindings/at91/at91rm9200/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9260/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9261/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9263/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9g45/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9n12/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9rl/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9x5/peripherals.h
 create mode 100644 include/dt-bindings/at91/common/peripherals.h
 create mode 100644 include/dt-bindings/at91/sama5d3/peripherals.h

-- 
1.7.9.5

