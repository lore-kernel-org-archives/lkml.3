Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaANO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:58:38 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:59161 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbaANO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:29 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v1 0/5] pinctrl: st: Add interrupt controller support.
Date: Tue, 14 Jan 2014 14:51:17 +0000
Message-ID: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Hi Linus W, 

This series of patches add interrupt controller support to ST pinctrl driver.
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

Patch 01: Is a minor typo fix.
Patch 02: Adds level interrupt support to pin controller.
Patch 03: Adds software edge trigger support.
Patch 04,05 : Updates STiH415, STiH416 dts files for interrupt support.

As Patch-01 only has a typo fix I did not move it out of this series.

Comments?

Thanks,
srini

Srinivas Kandagatla (5):
  pinctrl: st: Fix a typo in probe
  pinctrl: st: Add Interrupt support.
  pinctrl: st: Add software edge trigger interrupt support.
  ARM:STi: STiH416: Add interrupt support for pin controller
  ARM:STi: STiH415: Add interrupt support for pin controller

 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |   60 ++++-
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |   75 +++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |   81 ++++++
 drivers/pinctrl/pinctrl-st.c                       |  287 +++++++++++++++++++-
 4 files changed, 492 insertions(+), 11 deletions(-)

-- 
1.7.6.5

