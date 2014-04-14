Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaDNB4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:56:21 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:48206 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753513AbaDNB4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3867:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: alarm52_5393e3892b331
X-Filterd-Recvd-Size: 1700
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 05/19] random: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:37 -0700
Message-Id: <68f966febdc8972b31c5c7a7a88824814eb1c736.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..c71dfb6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1578,10 +1578,10 @@ static int proc_do_uuid(struct ctl_table *table, int write,
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

