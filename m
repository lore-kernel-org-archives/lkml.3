Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaFCTXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:23:20 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:6140 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbaFCTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:23:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOANscjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SCUy8jgRo3iEYB0Q8XhVWIfR2EKgSPS4o/ix2IFoM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/reiserfs/reiserfs.h: use ULLONG_MAX instead of ~0ULL
Date: Tue,  3 Jun 2014 21:22:04 +0200
Message-Id: <1401823324-4372-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more explicit kernel.h definition

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/reiserfs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 83d4eac..742ce52 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -1070,17 +1070,17 @@ static inline __u16 offset_v2_k_type(const struct offset_v2 *v2)
 static inline void set_offset_v2_k_type(struct offset_v2 *v2, int type)
 {
 	v2->v =
-	    (v2->v & cpu_to_le64(~0ULL >> 4)) | cpu_to_le64((__u64) type << 60);
+	    (v2->v & cpu_to_le64(ULLONG_MAX >> 4)) | cpu_to_le64((__u64) type << 60);
 }
 
 static inline loff_t offset_v2_k_offset(const struct offset_v2 *v2)
 {
-	return le64_to_cpu(v2->v) & (~0ULL >> 4);
+	return le64_to_cpu(v2->v) & (ULLONG_MAX >> 4);
 }
 
 static inline void set_offset_v2_k_offset(struct offset_v2 *v2, loff_t offset)
 {
-	offset &= (~0ULL >> 4);
+	offset &= (ULLONG_MAX >> 4);
 	v2->v = (v2->v & cpu_to_le64(15ULL << 60)) | cpu_to_le64(offset);
 }
 
-- 
1.8.4.5

