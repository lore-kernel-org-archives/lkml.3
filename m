Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3FDCPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:15:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28894 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab3FDCPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:15:31 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c1-51ad4dc1862e
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Dave Kleikamp'" <dave.kleikamp@oracle.com>,
        "'Vahram Martirosyan'" <vahram.martirosyan@linuxtesting.org>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  jfs: Several bugs in jfs_freeze() and
 jfs_unfreeze()
Date: Tue, 04 Jun 2013 11:15:29 +0900
Message-id: <000001ce60c9$622de130$2689a390$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAAzESPsA==
Content-language: ko
x-cr-hashedpuzzle: 19g= G+hq L1dx QOS/ SYz3 axB5 dJNn fGg0 jUbc jwEk nNhY oI+p
 pjzT sxOy vglj
 xMOr;5;ZABhAHYAZQAuAGsAbABlAGkAawBhAG0AcABAAG8AcgBhAGMAbABlAC4AYwBvAG0AOwBqAGgAYgBpAHIAZAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwB0AGEAYgBsAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHYAYQBoAHIAYQBtAC4AbQBhAHIAdABpAHIAbwBzAHkAYQBuAEAAbABpAG4AdQB4AHQAZQBzAHQAaQBuAGcALgBvAHIAZwA=;Sosha1_v1;7;{3E53EA3B-0B42-4D99-84B7-DE680673850E};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Tue,
 04 Jun 2013 02:15:17
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOQAtAHMAdABhAGIAbABlAF0AIAAgAGoAZgBzADoAIABTAGUAdgBlAHIAYQBsACAAYgB1AGcAcwAgAGkAbgAgAGoAZgBzAF8AZgByAGUAZQB6AGUAKAApACAAYQBuAGQAIABqAGYAcwBfAHUAbgBmAHIAZQBlAHoAZQAoACkA
x-cr-puzzleid: {3E53EA3B-0B42-4D99-84B7-DE680673850E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zY92DvmsDDWac07E48OwSs8WSZm6L
	y7vmsFks2PiI0WLVxRWsDqwed17/ZfX4+PQWi0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	vNx/lr3gvHDF2W1P2BsYL/J3MXJySAiYSPQ+OM4CYYtJXLi3nq2LkYtDSGAZo8SHqfPZYYpm
	rv/IApGYzijR9WoZO4Tzl1Fi55clzCBVbAK6EsfWb2EFsUUEvCVOTfnFDFLELNDCKHHixmWg
	BAdQB7fE6uYgkBpOAR6JdX86wXqFBYIl5i++zQRiswioShx59ogRxOYVsJM4/fgMG4QtKPFj
	8j2wU5kFtCTW7zzOBGHLS2xe85YZZLyEgLrEo7+6IGtFBKYwSjzf8JINokZEYt+Ld4wgCQmB
	NWwS7x4cgPrZVOLGjCfsEImf7BK7b0xlgbhCQOLb5EMsEFNlJTYdYIaol5Q4uOIGywRGqVlI
	bpqF5KZZSG6ahWT3AkaWVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghMT1xB+P9A9aHGJOB
	1k9klhJNzgemhLySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MDK/01EosoxOSzn++7hGpvbazFVK54OrVy/NjDHKPtJyQfa9j/eCSXoWZnwJ2Zfd
	tx5Wvdkwvfeae4ieOPfB7jMhYRxz7Gq3CZi7ihbl8M3qnM55NNxzp8ayBbL8Qfd/h8txbpc9
	1/fE7Rrz2SN+yet2z92Ulimpv2pxUBcT++TvDKnSBQkxSizFGYmGWsxFxYkA0EEYAP8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQd2DvmsDDd4s0rA48OwSs8WSZm6L
	y7vmsFks2PiI0WLVxRWsDqwed17/ZfX4+PQWi0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZrzcf5a94LxwxdltT9gbGC/ydzFyckgImEjMXP+RBcIW
	k7hwbz1bFyMXh5DAdEaJrlfL2CGcv4wSO78sYQapYhPQlTi2fgsriC0i4C1xasovZpAiZoEW
	RokTNy4DJTiAOrglVjcHgdRwCvBIrPvTCdYrLBAsMX/xbSYQm0VAVeLIs0eMIDavgJ3E6cdn
	2CBsQYkfk++BXcQsoCWxfudxJghbXmLzmrfMIOMlBNQlHv3VBVkrIjCFUeL5hpdsEDUiEvte
	vGMESUgIrGGTePfgANRrphI3Zjxhn8AoMgvJjllIdsxCsmMWklkLGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgQnjGfSOxhXNVgcYhTgYFTi4VXYsiZQiDWxrLgy9xCjBAezkghvr8va
	QCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqcD0xmeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXAqLHb5HPsmbX/hF+/W/vyV3WBm9fGP/clJcT6efUUxCKY
	u5R0V8cFRK3+wcu6Xu6nz6/UetWT5SF+ye13z+08OoV1W2/QyUM/2XcxZTz42OW0MmfiUrXD
	EzvVCw9lvZ4Ww2g76SPH1Fn8q/8pv18SGSCz9O1k1V32JwsmarVxeYYISfL7ff7Fr8RSnJFo
	qMVcVJwIAN2kjQFcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Vahram Martirosyan <vmartirosyan@gmail.com>"

commit e9b376671910d105c5e61103111b96209c729529 upstream

The mentioned functions do not pay attention to the error codes returned
by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings
to system crash later when writing to log.

The patch adds corresponding code to check and return the error codes
and to print correct error messages in case of errors.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 fs/jfs/super.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 1a543be..2502d39 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -611,11 +611,28 @@ static int jfs_freeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
+	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		txQuiesce(sb);
-		lmLogShutdown(log);
-		updateSuper(sb, FM_CLEAN);
+		rc = lmLogShutdown(log);
+		if (rc) {
+			jfs_error(sb, "jfs_freeze: lmLogShutdown failed");
+
+			/* let operations fail rather than hang */
+			txResume(sb);
+
+			return rc;
+		}
+		rc = updateSuper(sb, FM_CLEAN);
+		if (rc) {
+			jfs_err("jfs_freeze: updateSuper failed\n");
+			/*
+			 * Don't fail here. Everything succeeded except
+			 * marking the superblock clean, so there's really
+			 * no harm in leaving it frozen for now.
+			 */
+		}
 	}
 	return 0;
 }
@@ -627,13 +644,18 @@ static int jfs_unfreeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		updateSuper(sb, FM_MOUNT);
-		if ((rc = lmLogInit(log)))
-			jfs_err("jfs_unlock failed with return code %d",
rc);
-		else
-			txResume(sb);
+		rc = updateSuper(sb, FM_MOUNT);
+		if (rc) {
+			jfs_error(sb, "jfs_unfreeze: updateSuper failed");
+			goto out;
+		}
+		rc = lmLogInit(log);
+		if (rc)
+			jfs_error(sb, "jfs_unfreeze: lmLogInit failed");
+out:
+		txResume(sb);
 	}
-	return 0;
+	return rc;
 }
 
 static struct dentry *jfs_do_mount(struct file_system_type *fs_type,
-- 
1.7.9.5

