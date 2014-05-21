Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaEUIDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:03:50 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:15246
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752066AbaEUIDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:03:46 -0400
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <leo.li@freescale.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v5 0/3] DMA: Freescale: driver cleanups and enhancements
Date: Wed, 21 May 2014 16:03:00 +0800
Message-ID: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(85852003)(4396001)(83322001)(50226001)(21056001)(19580395003)(19580405001)(83072002)(86152002)(50986999)(77096999)(74502001)(93916002)(80022001)(88136002)(6806004)(99396002)(44976005)(86362001)(87936001)(74662001)(31966008)(47776003)(20776003)(36756003)(64706001)(33646001)(87286001)(92726001)(76482001)(2201001)(50466002)(102836001)(77982001)(46102001)(48376002)(81542001)(89996001)(92566001)(77156001)(62966002)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB303;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=hongbo.zhang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Hi Dan,
Please have a look at this 3/3 as Vinod mentioned.

Hi Vinod Koul,
Please have a look at the v5 patch set.

v4 -> v5 changes:
 - since previous 5 of 8 patches have been merged by Vinod, this iteration oly
   inludes the last 3 patches of v4.
 - patches order is changed for being reviewed and merged easier.
 - remove the .prepare functions, and use the suspend_late and resume_early in
   the suspend-and-resume patch.

v3 -> v4 changes:
 - Fixed a typo in [2/8] commit message.
 - There was a potential double call of list_del() when apply [4/8] only,
   although this defect is removed again in later [6/8]. This version 
   eliminates this problem by updating [4/8] and [6/8] slightly.
 - Updated [8/8] to use register access method introduced by [2/8]

v2 -> v3 change:
Only add "chan->pm_state = RUNNING" for patch[8/8].

v1 -> v2 change:
The only one change is introducing a new patch[1/7] to remove the unnecessary
macro FSL_DMA_LD_DEBUG, thus the total patches number is 8 now (was 7)

v1 notes:
Note that patch 2~6 had beed sent out for upstream before, but were together
with other storage patches at that time, that was not easy for being reviewed
and merged, so I send them separately this time.

Hongbo Zhang (3):
  DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
  DMA: Freescale: add suspend resume functions for DMA driver
  DMA: Freescale: change descriptor release process for supporting
    async_tx

 drivers/dma/fsldma.c |  297 ++++++++++++++++++++++++++++++++++++++------------
 drivers/dma/fsldma.h |   32 +++++-
 2 files changed, 260 insertions(+), 69 deletions(-)

-- 
1.7.9.5


