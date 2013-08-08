Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3HHG5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:57:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19760 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3HHG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:56:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Aug 2013 23:56:58 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 0/3] Add power control for lm90
Date: Thu, 8 Aug 2013 14:56:28 +0800
Message-ID: <1375944991-29182-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device lm90 can be controlled by the vdd rail.
Add function to power on/off the vdd.
Enable the nct1008 on Tegra114 Dalmore board, and set the vdd-regulator.

This series is v2, previous version patches:
[v1]: http://www.mail-archive.com/linux-tegra@vger.kernel.org/msg12034.html

Changes from v1:
1. if get regulator failed, we should continue to run probe function,
not return fail.
2. call regulator_put() in error handler and remove function.
3. add LM90 DT binding document.

Wei Ni (3):
  hwmon: (lm90) Add power control
  ARM: dt: t114 dalmore: add dt entry for nct1008
  Documentation: dt: hwmon: add OF document for lm90

 Documentation/devicetree/bindings/hwmon/lm90.txt |   20 +++++++++
 arch/arm/boot/dts/tegra114-dalmore.dts           |   10 ++++-
 drivers/hwmon/lm90.c                             |   49 ++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt

-- 
1.7.9.5

