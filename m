Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaDNB4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:56:25 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:38773 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754213AbaDNB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wren95_5450286536d39
X-Filterd-Recvd-Size: 1867
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 07/19] scsi: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:39 -0700
Message-Id: <f90d0a9335107a3855837d4089d8b35c84136380.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/scsi_sysctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 2b6b93f..546f162 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -12,7 +12,7 @@
 #include "scsi_priv.h"
 
 
-static ctl_table scsi_table[] = {
+static struct ctl_table scsi_table[] = {
 	{ .procname	= "logging_level",
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
@@ -21,14 +21,14 @@ static ctl_table scsi_table[] = {
 	{ }
 };
 
-static ctl_table scsi_dir_table[] = {
+static struct ctl_table scsi_dir_table[] = {
 	{ .procname	= "scsi",
 	  .mode		= 0555,
 	  .child	= scsi_table },
 	{ }
 };
 
-static ctl_table scsi_root_table[] = {
+static struct ctl_table scsi_root_table[] = {
 	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= scsi_dir_table },
-- 
1.8.1.2.459.gbcd45b4.dirty

