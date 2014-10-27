Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaJ0F0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:26:38 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:45796 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751844AbaJ0FZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4321:4605:5007:6261:10004:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:13255:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drum51_4de3f94da4630
X-Filterd-Recvd-Size: 1767
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Michael Buesch <m@bues.ch>
Cc: netdev@vger.kernel.org
Subject: [PATCH 08/11] ssb: driver_chip_comon_pmu: Fix probable mask then right shift defect
Date: Sun, 26 Oct 2014 22:25:04 -0700
Message-Id: <e68a49a228d8d2495630b4ef03a1f32b33fce7fe.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ssb/driver_chipcommon_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 1173a09..bc71583 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -621,8 +621,8 @@ static u32 ssb_pmu_get_alp_clock_clk0(struct ssb_chipcommon *cc)
 	u32 crystalfreq;
 	const struct pmu0_plltab_entry *e = NULL;
 
-	crystalfreq = chipco_read32(cc, SSB_CHIPCO_PMU_CTL) &
-		      SSB_CHIPCO_PMU_CTL_XTALFREQ >> SSB_CHIPCO_PMU_CTL_XTALFREQ_SHIFT;
+	crystalfreq = (chipco_read32(cc, SSB_CHIPCO_PMU_CTL) &
+		       SSB_CHIPCO_PMU_CTL_XTALFREQ) >> SSB_CHIPCO_PMU_CTL_XTALFREQ_SHIFT;
 	e = pmu0_plltab_find_entry(crystalfreq);
 	BUG_ON(!e);
 	return e->freq * 1000;
-- 
2.1.2

