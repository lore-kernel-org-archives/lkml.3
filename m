Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaAPPnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:43:50 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:35974 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbaAPPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:43:44 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v2 0/4] pinctrl: st: Add interrupt controller support.
Date: Thu, 16 Jan 2014 15:35:45 +0000
Message-ID: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Hi Linus W, 

Thankyou for reviewing v1 of the patch-set the comments were very useful.

This series of v2 patches add interrupt controller support to ST pinctrl
driver incorporating all the review comments.

ST pin controller GPIO bank can have one of the two possible types of
interrupt-wirings.

First type is via irqmux, single interrupt is used by multiple gpio
banks. This reduces number of interrupts numbers required by pin controller.
All these gpio banks belong to a single pin controller.

Second type has a dedicated interrupt per gpio bank. Interrupt number usage is
very high in this case.

This patch adds support to both these wirings.

Also, ST pin controller hardware only supports level triggered interrupts.
However for drivers like gpio keypad requires edge trigger interrupt support,
so one of the patch adds edge trigger interrupt support in software by using
the existing level trigger support in hardware.

Patch 01: Adds level interrupt support to pin controller.
Patch 02 Adds software edge trigger support.
Patch 03,04 : Updates STiH415, STiH416 dts files for interrupt support.


Changes since v1:
	Updated below changes suggest by Linus W.
	- Added updated example in binding document.
	- removed un-necessary varibles in st_gpio_bank and st_pinctrl struct.
	- renamed irq disabled/enabled functions with masked/unmasked
	  functions.
	- Fixed a issue in interrupt handler which could miss interrupts.
	- Added new hooks startup and shutdown which can mark gpio lines.
	- create irq mapping at probe stage instead of doing it in to_irq.
	- removed driver specfic irq_domain xlate function with generic one.
	- Added extra documention for software edge trigger support.
	- reformated few debug messages.

I did skip the first patch from my last v1 patchset as you have already
applied it.

Thanks,
srini


Srinivas Kandagatla (4):
  pinctrl: st: Add Interrupt support.
  pinctrl: st: Add software edge trigger interrupt support.
  ARM:STi: STiH416: Add interrupt support for pin controller
  ARM:STi: STiH415: Add interrupt support for pin controller

 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |   73 ++++-
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |   75 +++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |   81 +++++
 drivers/pinctrl/pinctrl-st.c                       |  337 +++++++++++++++++++-
 4 files changed, 558 insertions(+), 8 deletions(-)

-- 
1.7.6.5

