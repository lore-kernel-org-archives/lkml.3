Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaCQCcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:32:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12257 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaCQCcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:32:05 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-23-53265ea356af
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: print type for each segment in segment_info's
 show
Date: Mon, 17 Mar 2014 10:31:06 +0800
Message-id: <000001cf4189$14d1c310$3e754930$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9BiIs72K4eKgQQTeat+IDMzoOomg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd3FcWrBBhvOqVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHghlzBf8GKKXd2
	sjUwPuXpYuTkkBAwkbjT1sgIYYtJXLi3nq2LkYtDSGA6o0Tfk7OMEM4PRolp01eAVbEJqEgs
	7/jPBGKLCChKbHi/gR3EZhbIlLjXNIMZxBYWCJOY/eYVWA2LgKpE+4mrLCA2r4ClxLKpy5gh
	bEGJH5PvsUD0akms33mcCcKWl9i85i0zxEUKEjvOvmaE2KUnsWbKV2aIGnGJjUdusUxgFJiF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBgfxMegfjqgaLQ4wC
	HIxKPLwTlNWChVgTy4orcw8xSnAwK4nw6sUChXhTEiurUovy44tKc1KLDzFKc7AoifMebLUO
	FBJITyxJzU5NLUgtgskycXBKNTCuPfCUI0hkRfSfM5Jb/gvMOnDktOOWJ06pLXPa933cyHNM
	ze7WpvZVEx7fTeU+oydnzv2QobPI8ErN5N7pzwP5lj+Smm0Y+KZudldYvZN6mNOXNdOf7Vtz
	6vC70hkTqs6uv6I2JfTTnsXbl8VyXPHjW89qHv5MeKPEg7hSjuQ3TZtFtP/J8vy8p8RSnJFo
	qMVcVJwIAO+DvdpgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original segment_info's show looks out-of-format:
cat /proc/fs/f2fs/loop0/segment_info
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 512
512 512 512 512 512 512 512 0 0 512
348 0 263 0 0 512 0 0 512 512
512 512 0 512 512 512 512 512 512 512
512 512 511 328 512 512 512 512 512 512
512 512 512 512 512 512 512 0 0 175

Let's fix this and show type for each segment.
cat /proc/fs/f2fs/loop0/segment_info
format: segment_type|valid_blocks
segment_type(0:HD, 1:WD, 2:CD, 3:HN, 4:WN, 5:CN)
0    2|0   1|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0
10   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0
20   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0
30   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0
40   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0   0|0
50   3|0   3|0   3|0   3|0   3|0   3|0   3|0   0|0   3|0   3|0
60   3|0   3|0   3|0   3|0   3|0   3|0   3|0   3|0   3|0   3|512
70   3|512 3|512 3|512 3|512 3|512 3|512 3|512 3|0   3|0   3|512
80   3|0   3|0   3|0   3|0   3|0   3|512 3|0   3|0   3|512 3|512
90   3|512 0|512 3|274 0|512 0|512 0|512 0|512 0|512 0|512 3|512
100  3|512 0|512 3|511 0|328 3|512 0|512 0|512 3|512 0|512 0|512
110  0|512 0|512 0|512 0|512 0|512 0|512 0|512 5|0   4|0   3|512

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3a51d7a..057a3ef 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -544,8 +544,16 @@ static int segment_info_seq_show(struct seq_file *seq, void *offset)
 			le32_to_cpu(sbi->raw_super->segment_count_main);
 	int i;
 
+	seq_puts(seq, "format: segment_type|valid_blocks\n"
+		"segment_type(0:HD, 1:WD, 2:CD, 3:HN, 4:WN, 5:CN)\n");
+
 	for (i = 0; i < total_segs; i++) {
-		seq_printf(seq, "%u", get_valid_blocks(sbi, i, 1));
+		struct seg_entry *se = get_seg_entry(sbi, i);
+
+		if ((i % 10) == 0)
+			seq_printf(seq, "%-5d", i);
+		seq_printf(seq, "%d|%-3u", se->type,
+					get_valid_blocks(sbi, i, 1));
 		if ((i % 10) == 9 || i == (total_segs - 1))
 			seq_putc(seq, '\n');
 		else
-- 
1.7.9.5


