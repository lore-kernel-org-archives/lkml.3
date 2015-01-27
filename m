Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbbA0V0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:26:44 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44045 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbbA0V0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:26:43 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Dmitry Eremin <dmitry.eremin@intel.com>, Peng Tao <bergwolf@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: libcfs: nidstrings: Change type in printf format string
Date: Tue, 27 Jan 2015 22:29:59 +0100
Message-Id: <1422394199-7920-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong type in printf format string, requires 'unsigned int'
but the argument type is 'int'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 47c239f..634ad09 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -343,7 +343,7 @@ libcfs_lnd2str(int lnd)
 		return nf->nf_name;
 
 	str = libcfs_next_nidstring();
-	snprintf(str, LNET_NIDSTR_SIZE, "?%u?", lnd);
+	snprintf(str, LNET_NIDSTR_SIZE, "?%d?", lnd);
 	return str;
 }
 EXPORT_SYMBOL(libcfs_lnd2str);
@@ -369,11 +369,11 @@ libcfs_net2str(__u32 net)
 	char	     *str = libcfs_next_nidstring();
 
 	if (nf == NULL)
-		snprintf(str, LNET_NIDSTR_SIZE, "<%u:%u>", lnd, num);
+		snprintf(str, LNET_NIDSTR_SIZE, "<%d:%d>", lnd, num);
 	else if (num == 0)
 		snprintf(str, LNET_NIDSTR_SIZE, "%s", nf->nf_name);
 	else
-		snprintf(str, LNET_NIDSTR_SIZE, "%s%u", nf->nf_name, num);
+		snprintf(str, LNET_NIDSTR_SIZE, "%s%d", nf->nf_name, num);
 
 	return str;
 }
@@ -397,7 +397,7 @@ libcfs_nid2str(lnet_nid_t nid)
 	str = libcfs_next_nidstring();
 
 	if (nf == NULL)
-		snprintf(str, LNET_NIDSTR_SIZE, "%x@<%u:%u>", addr, lnd, nnum);
+		snprintf(str, LNET_NIDSTR_SIZE, "%x@<%d:%d>", addr, lnd, nnum);
 	else {
 		nf->nf_addr2str(addr, str);
 		nob = strlen(str);
@@ -405,7 +405,7 @@ libcfs_nid2str(lnet_nid_t nid)
 			snprintf(str + nob, LNET_NIDSTR_SIZE - nob, "@%s",
 				 nf->nf_name);
 		else
-			snprintf(str + nob, LNET_NIDSTR_SIZE - nob, "@%s%u",
+			snprintf(str + nob, LNET_NIDSTR_SIZE - nob, "@%s%d",
 				 nf->nf_name, nnum);
 	}
 
-- 
1.7.10.4

