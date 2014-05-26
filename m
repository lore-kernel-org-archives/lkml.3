Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaEZO7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:59:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752065AbaEZO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:58:43 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/5] mfd: axp20x: add AXP221 PMIC support
Date: Mon, 26 May 2014 16:58:07 +0200
Message-Id: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds basic support for the X-Powers' AXP221 PMIC.

At the moment the MFD device only exposes the AXP221 regulators but other
subdevices might be added later.

I'm still waiting for inputs regarding the ipsout regulator representation:
 * The ipsout regulator is currently represented as a fixed regulator
   providing a 5v output, and this is not exactly the case.
   AFAIU (here's is the datasheet traduction if you want to check [1]), the
   ipsout output is a multiplexer that choose among vbus (5V), acin (12V
   which is then converted to 5V) and the battery power supply (3,5 -> 4,2 V).
   This means the output voltage of ipsout vary between 3,5V and 5V.
   How can we express this kind of muxer in the regulator framework (is there
   already something available ?) ?
   Note that the power supply selection is automatic, though we could force
   one power supply, but then we loose the ability to unplug one power supply
   without impacting the system.

Best Regards,

Boris

[1] http://linux-sunxi.org/AXP221#Regulators

Changes since v1:
 - merge code with the axp20x driver

Boris BREZILLON (5):
  mfd: axp20x: add AXP221 PMIC support
  regulator: axp20x: prepare support for multiple AXP chip families
  regulator: axp20x: add support for AXP221 regulators
  regulator: axp20x: reset probe data before each probe
  regulator: axp20x: resolve self dependency issue

 drivers/mfd/axp20x.c                 |  58 +++++++-
 drivers/regulator/axp20x-regulator.c | 250 +++++++++++++++++++++++++++--------
 include/linux/mfd/axp20x.h           |  56 ++++++++
 3 files changed, 304 insertions(+), 60 deletions(-)

-- 
1.8.3.2

