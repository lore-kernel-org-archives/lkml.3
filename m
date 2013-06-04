Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3FDJ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:58:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab3FDJ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:58:35 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>, <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v2 0/2] PM / AVS: SmartReflex: optimization series
Date: Tue, 4 Jun 2013 12:58:31 +0300
Message-ID: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series introduces a few optimizations for SmartReflex driver.

1. devm_* API usage for SmartReflex.
Benefits:
- auto handling of resources - allocation/auto free, map/auto unmap.
- lot of error checks can be dropped.

2. Another small optimization resolves order of initialization between SmartReflex driver
and SmartReflex class. Class is initialized before driver.

Patches are based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
tag: v3.10-rc4

Verified on OMAP4430. Boot - OK. SmartReflex registers debug dump - OK

Series v2 contains:
- spurious #define removed from "PM / AVS: SmartReflex: use devm_* API to initialize SmartReflex"
- rebased to v3.10-rc4

Andrii Tseglytskyi (2):
  PM / AVS: SmartReflex: use devm_* API to initialize SmartReflex
  PM / AVS: SmartReflex/class3: Fix order of initialization of SR class
    and SR driver

 arch/arm/mach-omap2/smartreflex-class3.c |    2 +-
 drivers/power/avs/smartreflex.c          |   85 ++++++++----------------------
 2 files changed, 22 insertions(+), 65 deletions(-)

-- 
1.7.9.5

