Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3A2JHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:07:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9019 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3A2JHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:07:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Jan 2013 01:05:17 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] mfd/regulator: tps65090: add DT support and suspend/resume cleanups
Date: Tue, 29 Jan 2013 14:35:14 +0530
Message-ID: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series add DT support on TPS65090 device.

Also remove the suspend/resume implementation as it duplicates with
irq_suspend/irq_resume().

Changes from V1:
- Remove non-required code from the change for checking the match.
- Remove pdata allocation on mfd driver.
- renames some of the property as suggested by Stephen.
- Rebased the changes on 20130128.

Laxman Dewangan (4):
  mfd: tps65090: add DT support for tps65090
  regulator: tps65090: add DT support
  mfd: tps65090: Pass irq domain when adding mfd sub devices
  mfd: tps65090: remove suspend/resume callbacks

 .../devicetree/bindings/regulator/tps65090.txt     |  122 ++++++++++++++++++++
 drivers/mfd/tps65090.c                             |   47 +++-----
 drivers/regulator/tps65090-regulator.c             |  106 ++++++++++++++++-
 3 files changed, 243 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt

