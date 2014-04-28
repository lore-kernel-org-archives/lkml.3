Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaD1BdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42835 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.332280880@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 94/94] Revert "alpha: fix broken network checksum"
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit b93b90ff7c50288d602108ae1a09673df3f799a8, which
was commit 0ef38d70d4118b2ce1a538d14357be5ff9dc2bbd upstream.
It was intended to fix a regression which never occurred in 3.2.

--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -373,11 +373,6 @@
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
-	__wsum checksum;
-	mm_segment_t oldfs = get_fs();
-	set_fs(KERNEL_DS);
-	checksum = csum_partial_copy_from_user((__force const void __user *)src,
-						dst, len, sum, NULL);
-	set_fs(oldfs);
-	return checksum;
+	return csum_partial_copy_from_user((__force const void __user *)src,
+			dst, len, sum, NULL);
 }

