Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3GJL1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:27:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10048 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3GJL1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:27:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Jul 2013 04:26:27 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <swarren@wwwdotorg.org>, <linux@roeck-us.net>,
        <thierry.reding@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 0/3] Lm90 Enhancements
Date: Wed, 10 Jul 2013 19:25:36 +0800
Message-ID: <1373455539-2831-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhance the lm90 driver,
it make the driver more readable and easier to use thermal framework.

This series is v2, previous version patches:
[RFC]: http://thread.gmane.org/gmane.linux.power-management.general/31056
[v1]: http://thread.gmane.org/gmane.linux.ports.tegra/11710/

Changes from v1:
1. change the string "irq" to "IRQ"
2. add macro defines for the alarm status
3. consider the shared IRQ.

Changes from RFC:
1. change _show_temp() to read_temp(), _set_temp() to write_temp().
2. simply return value for the read_temp(), not use pointer.
3. use devm_request_threaded_irq() to request irq and set flag IRQF_ONESHOT.

Wei Ni (3):
  hwmon: (lm90) split set&show temp as common codes
  hwmon: (lm90) add support to handle IRQ.
  hwmon: (lm90) use enums for the indexes of temp8 and temp11

 drivers/hwmon/lm90.c |  374 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 253 insertions(+), 121 deletions(-)

-- 
1.7.9.5

