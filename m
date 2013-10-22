Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3JVWfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:35:53 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:49149 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755167Ab3JVWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3867:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trip03_58f476fd503d
X-Filterd-Recvd-Size: 1644
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/24] random: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:49 -0700
Message-Id: <c9288e9d6cb3daa0f41518dcd536081d553e2604.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6f20317..91863d1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1508,10 +1508,10 @@ static int proc_do_uuid(struct ctl_table *table, int write,
 /*
  * Return entropy available scaled to integral bits
  */
-static int proc_do_entropy(ctl_table *table, int write,
+static int proc_do_entropy(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	ctl_table fake_table;
+	struct ctl_table fake_table;
 	int entropy_count;
 
 	entropy_count = *(int *)table->data >> ENTROPY_SHIFT;
-- 
1.8.1.2.459.gbcd45b4.dirty

