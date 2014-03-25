Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaCYTfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:35:18 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:48474 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753770AbaCYTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4605:5007:6261:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hot23_109c9511e143f
X-Filterd-Recvd-Size: 2654
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/5] powerpc: Convert last uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:03 -0700
Message-Id: <1f882e154533d5f76a6d740cf27a97e6e1500718.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/pseries/nvram.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index d7096f2..0cc240b 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -298,13 +298,13 @@ int nvram_write_os_partition(struct nvram_os_partition *part, char * buff,
 
 	rc = ppc_md.nvram_write((char *)&info, sizeof(struct err_log_info), &tmp_index);
 	if (rc <= 0) {
-		pr_err("%s: Failed nvram_write (%d)\n", __FUNCTION__, rc);
+		pr_err("%s: Failed nvram_write (%d)\n", __func__, rc);
 		return rc;
 	}
 
 	rc = ppc_md.nvram_write(buff, length, &tmp_index);
 	if (rc <= 0) {
-		pr_err("%s: Failed nvram_write (%d)\n", __FUNCTION__, rc);
+		pr_err("%s: Failed nvram_write (%d)\n", __func__, rc);
 		return rc;
 	}
 	
@@ -351,15 +351,14 @@ int nvram_read_partition(struct nvram_os_partition *part, char *buff,
 					sizeof(struct err_log_info),
 					&tmp_index);
 		if (rc <= 0) {
-			pr_err("%s: Failed nvram_read (%d)\n", __FUNCTION__,
-									rc);
+			pr_err("%s: Failed nvram_read (%d)\n", __func__, rc);
 			return rc;
 		}
 	}
 
 	rc = ppc_md.nvram_read(buff, length, &tmp_index);
 	if (rc <= 0) {
-		pr_err("%s: Failed nvram_read (%d)\n", __FUNCTION__, rc);
+		pr_err("%s: Failed nvram_read (%d)\n", __func__, rc);
 		return rc;
 	}
 
@@ -869,7 +868,7 @@ static void oops_to_nvram(struct kmsg_dumper *dumper,
 		break;
 	default:
 		pr_err("%s: ignoring unrecognized KMSG_DUMP_* reason %d\n",
-						__FUNCTION__, (int) reason);
+		       __func__, (int) reason);
 		return;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

