Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967480Ab3HIGVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:21:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17606 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966649Ab3HIGVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:21:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-11-52048a4db378
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: fix the use of XATTR_NODE_OFFSET
Date: Fri, 09 Aug 2013 15:20:28 +0900
Message-id: <1376029230-303-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zQ13fLpYggyeXRSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypjbXFrQwFdx5mw/
	SwNjL3cXIyeHhICJxIR/r5kgbDGJC/fWs3UxcnEICSxjlJi3/BUrTNHrrgZGiMR0RomG3VeY
	IZw2JokH7ZOBMhwcbALaEpv3G4A0iAgwSyyYeh6sgVlgAqPE/0XvWUASwgLWElcmPWIHsVkE
	VCXONdxlB+nlFXCVeDe1CmKZrsSiEwehFt9nk3i5lRWiXEDi2+RDLCDlEgKyEpsOMEOUSEoc
	XHGDZQKj4AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIeHXv4Px7gHrQ4zJQOMmMkuJ
	JucDwzevJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYzqBVGvDsRK1ey0zskyWsT0MOrf011nmK1Kk3w35RyW/e5qZ/dxk14vv0+i0k9BPRfZda0V
	HqX77zuJKXZujtMuPWH8/NrW7RFui2aGXfGwWbeT84cc9woZhbvWz3937JPvveL3qrn3El9V
	v35lZo3LHk4LixLJ6w/vry9mfzUjUlGXX6mMV4mlOCPRUIu5qDgRAO+auKRVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQV3fLpYgg/ZDAhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWbMbS4taOCrOHO2n6WBsZe7i5GTQ0LAROJ1VwMjhC0mceHeerYuRi4OIYHp
	jBINu68wQzhtTBIP2icDVXFwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgLWEtc
	mfSIHcRmEVCVONdwlx2kl1fAVeLd1CqIZboSi04cZJ3AyL2AkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnB4P5PawbiyweIQowAHoxIPr+J25iAh1sSy4srcQ4wSHMxKIrwvsoBCvCmJ
	lVWpRfnxRaU5qcWHGJOBlk9klhJNzgfGXl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1ME6NrW+t2+4ksXVVhprO+6Yr374FFEzvkzzZ2W6Y9vHMnYCDh59m
	X5J0KIphfTjx+NW5At4BB9TZ9mzpff/q1uc3eaxPVvx7LycVcYttclFWfmeeXOPEk+uOf38b
	JRu9pF6zbsPa4zWsMi0MrbZxVxg4V1hEe3fOcVz3xdl1cvrqSbq821JCJymxFGckGmoxFxUn
	AgChC51kswIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the use of XATTR_NODE_OFFSET.

o The offset should not use several MSB bits which are used by marking node
blocks.

o IS_DNODE should handle XATTR_NODE_OFFSET to avoid potential abnormality
during the fsync call.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h | 12 +++++++-----
 fs/f2fs/node.h |  4 ++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d8e386ce..eb8c45b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -135,11 +135,13 @@ static inline int update_sits_in_cursum(struct f2fs_summary_block *rs, int i)
 /*
  * For INODE and NODE manager
  */
-#define XATTR_NODE_OFFSET	(-1)	/*
-					 * store xattrs to one node block per
-					 * file keeping -1 as its node offset to
-					 * distinguish from index node blocks.
-					 */
+/*
+ * XATTR_NODE_OFFSET stores xattrs to one node block per file keeping -1
+ * as its node offset to distinguish from index node blocks.
+ * But some bits are used to mark the node block.
+ */
+#define XATTR_NODE_OFFSET	((((unsigned int)-1) << OFFSET_BIT_SHIFT) \
+				>> OFFSET_BIT_SHIFT)
 enum {
 	ALLOC_NODE,			/* allocate a new node page if needed */
 	LOOKUP_NODE,			/* look up a node without readahead */
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 87349c4..3496bb3 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -229,6 +229,10 @@ static inline block_t next_blkaddr_of_node(struct page *node_page)
 static inline bool IS_DNODE(struct page *node_page)
 {
 	unsigned int ofs = ofs_of_node(node_page);
+
+	if (ofs == XATTR_NODE_OFFSET)
+		return false;
+
 	if (ofs == 3 || ofs == 4 + NIDS_PER_BLOCK ||
 			ofs == 5 + 2 * NIDS_PER_BLOCK)
 		return false;
-- 
1.8.3.1.437.g0dbd812

