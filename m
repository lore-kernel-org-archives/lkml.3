Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3ILLXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:23:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10096 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3ILLXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:23:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Sep 2013 04:20:35 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <broonie@kernel.org>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v4 0/3] Add power control for lm90
Date: Thu, 12 Sep 2013 19:24:18 +0800
Message-ID: <1378985061-28547-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device lm90 can be controlled by the vcc rail.
Add function to power on/off the vcc.

This series must base on Mark's new dummy regulator support.

This series is v4, previous version patches are:
[v3]: http://www.spinics.net/lists/lm-sensors/msg39503.html
[v2]: http://www.spinics.net/lists/arm-kernel/msg265373.html
[v1]: http://www.mail-archive.com/linux-tegra@vger.kernel.org/msg12034.html

Changes from v3:
1. change to use devm_regulator_get, as per discussion in previous patches.
2. just return errors when get error from regulator_get(), Mark's new dummy
regulator can cope with errors.
3. add vendor prefix for GMT
3. list manufacturer in the binding doc.

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

Wei Ni (3):
  hwmon: (lm90) Add power control
  of: add vendor prefix for GMT
  Documentation: dt: hwmon: add OF document for LM90

 Documentation/devicetree/bindings/hwmon/lm90.txt   |   44 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/hwmon/lm90.c                               |   20 +++++++++
 3 files changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt

-- 
1.7.9.5

