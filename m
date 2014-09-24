Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaIXKRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:17:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52632 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaIXKQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:16:59 -0400
X-AuditID: cbfee61a-f79c06d000004e71-36-54229a19401b
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/6 v2] f2fs: add a new mount option for inline dir
Date: Wed, 24 Sep 2014 18:16:13 +0800
Message-id: <003d01cfd7e0$ac6b40f0$0541c2d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X344fvmvSTyOGThSAFlrIV5rCvw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAV3JWUohBkt/KFpc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48PCM8wF
	37krjk38wdrA+IGzi5GTQ0LARGLXvjfsELaYxIV769m6GLk4hAQWMUocu/2bHcL5wSix/t5q
	VpAqNgEVieUd/5lAbBEBL4lJ+0+wgNjMAh4SjR3fwWqEBXwl2s89Barh4GARUJW4cK4IJMwr
	YCkx7dIhJghbUOLH5HtQrVoS63ceZ4Kw5SU2r3nLDHGQgsSOs68ZIVbpScyf+ZQVokZcYuOR
	WywTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEg/k9rB
	uLLB4hCjAAejEg/vBHGlECHWxLLiytxDjBIczEoivK96gEK8KYmVValF+fFFpTmpxYcYpTlY
	lMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYU10rfjJcDdvAbsJ0qv683c8fmWfqNif1sjR6
	btyX+fZJhtMR7bYNs2fUPmQ0tZJg8zlTWLqxPsRA79ju/qP/dpXdvOb9ukd6xcX4iTLFgoIP
	bi24tqFaNnXuugPc35nt11/mLc2pP9c3ob0hMjn/9gn7RgffUwsY/rnmTl98Y89XqQOhUavb
	lFiKMxINtZiLihMBHjaQDWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new mount option 'inline_dentry' for inline dir.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bb6b568..9e03488 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -51,6 +51,7 @@ enum {
 	Opt_disable_ext_identify,
 	Opt_inline_xattr,
 	Opt_inline_data,
+	Opt_inline_dentry,
 	Opt_flush_merge,
 	Opt_nobarrier,
 	Opt_err,
@@ -69,6 +70,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_disable_ext_identify, "disable_ext_identify"},
 	{Opt_inline_xattr, "inline_xattr"},
 	{Opt_inline_data, "inline_data"},
+	{Opt_inline_dentry, "inline_dentry"},
 	{Opt_flush_merge, "flush_merge"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_err, NULL},
@@ -340,6 +342,9 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_inline_data:
 			set_opt(sbi, INLINE_DATA);
 			break;
+		case Opt_inline_dentry:
+			set_opt(sbi, INLINE_DENTRY);
+			break;
 		case Opt_flush_merge:
 			set_opt(sbi, FLUSH_MERGE);
 			break;
@@ -560,6 +565,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",disable_ext_identify");
 	if (test_opt(sbi, INLINE_DATA))
 		seq_puts(seq, ",inline_data");
+	if (test_opt(sbi, INLINE_DENTRY))
+		seq_puts(seq, ",inline_dentry");
 	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
 		seq_puts(seq, ",flush_merge");
 	if (test_opt(sbi, NOBARRIER))
-- 
2.0.1.474.g72c7794


