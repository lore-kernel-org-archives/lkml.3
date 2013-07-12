Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3GLHuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:50:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14697 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab3GLHuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:50:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 12 Jul 2013 00:47:48 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <thierry.reding@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 0/4] Lm90 Enhancements
Date: Fri, 12 Jul 2013 15:48:03 +0800
Message-ID: <1373615287-18502-1-git-send-email-wni@nvidia.com>
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
[v2]: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg465555.html

Changes from v2:
1. update the defines for status bit, and go into a separate patch.
2. introduce the new lm90_is_tripped() for lm90_irq_thread and lm90_alert.

Changes from v1:
1. change the string "irq" to "IRQ"
2. add macro defines for the alarm status
3. consider the shared IRQ.

Changes from RFC:
1. change _show_temp() to read_temp(), _set_temp() to write_temp().
2. simply return value for the read_temp(), not use pointer.
3. use devm_request_threaded_irq() to request irq and set flag IRQF_ONESHOT.

Wei Ni (4):
  hwmon: (lm90) split set&show temp as common codes
  hwmon: (lm90) use macro defines for the status bit
  hwmon: (lm90) add support to handle IRQ
  hwmon: (lm90) use enums for the indexes of temp8 and temp11

 drivers/hwmon/lm90.c |  387 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 256 insertions(+), 131 deletions(-)

-- 
1.7.9.5

