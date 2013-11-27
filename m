Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab3K0A7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:59:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3K0A7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Steve Dickson <steved@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 059/116] NFSv4.2: Fix a mismatch between Linux labeled NFS and the NFSv4.2 spec
Date: Tue, 26 Nov 2013 16:57:12 -0800
Message-Id: <20131127005741.024514497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f3f5a0f8cc40b942f4c0ae117df82eeb65f07d4d upstream.

In the spec, the security label attribute id is '80', which means that
it should be bit number 80-64 == 16 in the 3rd word of the bitmap.

Fixes: 4488cc96c581: NFS: Add NFSv4.2 protocol constants
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Steve Dickson <steved@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/nfs4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


