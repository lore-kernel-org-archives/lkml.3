Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3IIK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:28:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13155 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3IIK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:28:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Sep 2013 03:28:50 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>
CC: <broonie@kernel.org>, <swarren@wwwdotorg.org>, <lm-sensors@lm-sensors.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 0/2] Add power control for lm90
Date: Mon, 9 Sep 2013 18:29:10 +0800
Message-ID: <1378722552-10357-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device lm90 can be controlled by the vcc rail.
Add function to power on/off the vcc.

This series is v3, previous version patches are:
[v2]: http://www.spinics.net/lists/arm-kernel/msg265373.html
[v1]: http://www.mail-archive.com/linux-tegra@vger.kernel.org/msg12034.html

Changes from v2:
1. use devm_regulator_get_optional(), as suggested by Mark.
2. remove the lm90_power_control(), enable the regulator in the probe()
directly, so the codes are more clear, as suggested by Alexander and Guenter.
3. change the binding documentation, as per Stephen suggestion.
4. couple of changes, as per previous review.

Changes from v1:
1. if get regulator failed, we should continue to run probe function,
not return fail.
2. call regulator_put() in error handler and remove function.
3. add LM90 DT binding document.

Wei Ni (2):
  hwmon: (lm90) Add power control
  Documentation: dt: hwmon: add OF document for LM90

 Documentation/devicetree/bindings/hwmon/lm90.txt |   44 ++++++++++++++++++++++
 drivers/hwmon/lm90.c                             |   25 ++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt

-- 
1.7.9.5

