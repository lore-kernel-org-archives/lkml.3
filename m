Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaKXGSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:18:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10464 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaKXGQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:16:45 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-7d-5472cd4b68d4
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 4/10] xfsprogs: xfs_io: add finsert command for insert range
 via fallocate
Date: Mon, 24 Nov 2014 15:16:42 +0900
Message-id: <002d01d007ae$374e80e0$a5eb82a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrMy8LNEDdO5mTqa623W1G8zaIQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQNf7bFGIwZQDnBZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoEr49eB1ywFdwUrnk1YxdbAOIOvi5GTQ0LAROLHtF/MELaYxIV769m6
	GLk4hASWMkq03mlmhinas+svE0RiOqPEm9lrmCGcv4wSe9vOMXYxcnCwCWhL/NkiCtIgIuAq
	Me/ud0aQGmaQSRcfP2EESQgLxEscmP8OzGYRUJWY9HAZE4jNK2ApsWzxBjYIW1Dix+R7LCA2
	s4CWxPqdx5kgbHmJzWveQl2kILHj7GtGiGV6Ejf2dEDVi0jse/EObLGEwCV2iYsNr5gglglI
	fJt8iAXkUAkBWYlNB6DmSEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSi
	V5yYW1yal66XnJ+7iREYj6f/PZuwg/HeAetDjAIcjEo8vB82FoUIsSaWFVfmHmI0BbpoIrOU
	aHI+MOrzSuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WMZ27fP6skcvUxtOp8lwztFkiox0Wlo5cYca97yvVSsqmqZF1Db9jgya0xYk+MnyLp/7Wus5
	ldULZ37fmsTJNHlD3dPk6xf5F2bVnVR4mrHvnpvLqaU6gmvjv534cVzQrZh988+ALXq+5p37
	UhyE9llcXb9W32ffnpx/+2MfbEmdZb8x1kNDTYmlOCPRUIu5qDgRAHjpAfbCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV3vs0UhBqsPMFksnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBm/DrxmKbgrWPFswiq2BsYZ
	fF2MnBwSAiYSe3b9ZYKwxSQu3FvP1sXIxSEkMJ1R4s3sNcwQzl9Gib1t5xi7GDk42AS0Jf5s
	EQVpEBFwlZh39zsjSA2zwFJGiYuPnzCCJIQF4iUOzH8HZrMIqEpMergMbAOvgKXEssUb2CBs
	QYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIZbpSdzY0wFVLyKx78U7xgmMArOQ
	jJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM42p9J7WBc2WBxiFGA
	g1GJh/fDxqIQIdbEsuLK3EOMEhzMSiK8Z/8VhgjxpiRWVqUW5ccXleakFh9iNAX6dCKzlGhy
	PjAR5ZXEGxqbmBlZGpkbWhgZmyuJ8964mRsiJJCeWJKanZpakFoE08fEwSnVwBi61aV3Go+7
	R6tB9JybDRkSmxzTv0ebfrodfrl1V0vmLuf9rp9s5iTP+/V5l2/IqZfP1ilqpZ4IyEn5MVVx
	1qKiNVsOp90/uDlv7qYKDZ9H8Wl3OBh1J9guSvD65r/twtKLkp9qBdj9GPeWmTo0V4X2Fs94
	ZX99DmNxquiWWvE7NZU1Hxv3zVNiKc5INNRiLipOBABhA9lUDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 io/prealloc.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index aba6b44..11b1e12 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -37,6 +37,10 @@
 #define FALLOC_FL_ZERO_RANGE 0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE 0x20
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -46,6 +50,7 @@ static cmdinfo_t zero_cmd;
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
 static cmdinfo_t fcollapse_cmd;
+static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 #endif
 
@@ -169,11 +174,14 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "ckp")) != EOF) {
+	while ((c = getopt(argc, argv, "cikp")) != EOF) {
 		switch (c) {
 		case 'c':
 			mode = FALLOC_FL_COLLAPSE_RANGE;
 			break;
+		case 'i':
+			mode = FALLOC_FL_INSERT_RANGE;
+			break;
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
@@ -237,6 +245,25 @@ fcollapse_f(
 }
 
 static int
+finsert_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_INSERT_RANGE;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+
+static int
 fzero_f(
 	int		argc,
 	char		**argv)
@@ -345,6 +372,16 @@ prealloc_init(void)
 	_("de-allocates space and eliminates the hole by shifting extents");
 	add_command(&fcollapse_cmd);
 
+	finsert_cmd.name = "finsert";
+	finsert_cmd.cfunc = finsert_f;
+	finsert_cmd.argmin = 2;
+	finsert_cmd.argmax = 2;
+	finsert_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	finsert_cmd.args = _("off len");
+	finsert_cmd.oneline =
+	_("creates new space for writing within file by shifting extents");
+	add_command(&finsert_cmd);
+
 	fzero_cmd.name = "fzero";
 	fzero_cmd.cfunc = fzero_f;
 	fzero_cmd.argmin = 2;
-- 
1.7.11-rc0

