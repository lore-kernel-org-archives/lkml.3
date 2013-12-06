Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162377Ab3LFNMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:12:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162099Ab3LFNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Steve Dickson <steved@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 247/272] NFSv4.2: Fix a mismatch between Linux labeled NFS and the NFSv4.2 spec
Date: Fri,  6 Dec 2013 12:58:56 +0000
Message-Id: <1386334761-25517-248-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f3f5a0f8cc40b942f4c0ae117df82eeb65f07d4d upstream.

In the spec, the security label attribute id is '80', which means that
it should be bit number 80-64 == 16 in the 3rd word of the bitmap.

Fixes: 4488cc96c581: NFS: Add NFSv4.2 protocol constants
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Steve Dickson <steved@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/nfs4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index e36dee5..3859ddb 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -395,7 +395,7 @@ enum lock_type4 {
 #define FATTR4_WORD1_FS_LAYOUT_TYPES    (1UL << 30)
 #define FATTR4_WORD2_LAYOUT_BLKSIZE     (1UL << 1)
 #define FATTR4_WORD2_MDSTHRESHOLD       (1UL << 4)
-#define FATTR4_WORD2_SECURITY_LABEL     (1UL << 17)
+#define FATTR4_WORD2_SECURITY_LABEL     (1UL << 16)
 
 /* MDS threshold bitmap bits */
 #define THRESHOLD_RD                    (1UL << 0)
-- 
1.8.3.2

