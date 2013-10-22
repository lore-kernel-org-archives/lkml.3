Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3JVWas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:48 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:56422 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755523Ab3JVWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sun82_674a5476025c
X-Filterd-Recvd-Size: 1779
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: [PATCH 08/24] md: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:51 -0700
Message-Id: <97bd203891c6b2c45b2e77c31edda1b4149782f2.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8a0d762..7b57639 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -112,7 +112,7 @@ static inline int speed_max(struct mddev *mddev)
 
 static struct ctl_table_header *raid_table_header;
 
-static ctl_table raid_table[] = {
+static struct ctl_table raid_table[] = {
 	{
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
@@ -130,7 +130,7 @@ static ctl_table raid_table[] = {
 	{ }
 };
 
-static ctl_table raid_dir_table[] = {
+static struct ctl_table raid_dir_table[] = {
 	{
 		.procname	= "raid",
 		.maxlen		= 0,
@@ -140,7 +140,7 @@ static ctl_table raid_dir_table[] = {
 	{ }
 };
 
-static ctl_table raid_root_table[] = {
+static struct ctl_table raid_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
-- 
1.8.1.2.459.gbcd45b4.dirty

