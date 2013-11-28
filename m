Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3K1HnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:43:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50257 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3K1HnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:43:07 -0500
X-AuditID: cbfee61a-b7f316d000007e34-b3-5296f409b858
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 2/5] f2fs: add unlikely macro for compiler
 optimization
Date: Thu, 28 Nov 2013 15:42:35 +0800
Message-id: <003301ceec0d$77ddaef0$67990cd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7sDFzZbW/ulEtxSdiastXaqqYc1Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQV3OL9OCDM7st7S4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujC9N81kL
	TrBUrN7exNLAeIa5i5GTQ0LAROLb2wWMELaYxIV769m6GLk4hASmM0q8/76FFcL5wSjx4/ty
	NpAqNgEVieUd/5lAbBEBRYkN7zewgxQxC8xglDg89x8rSEJYIETi/8MesLEsAqoS/c9ng8V5
	BSwluv5+ZIOwBSV+TL7HAmIzC2hI9C/awAZhy0tsXvMW6jwFiR1nXzNCLNOTaLx/lxGiRlxi
	45FbLBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwWD+T
	2sG4ssHiEKMAB6MSD6+EzrQgIdbEsuLK3EOMEhzMSiK8CsVAId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYyTzaILrf0715+LKGP77beiwfyyYMLkS7em
	xBuL71vT8MV6ZswziQTGKoP0oFcL2ibHSU4TWPw/+Mf+om8nP06TOiu/LeO7Wdf9PItfIb2Z
	zxvzw1W1r8hV8T51euTaH1k+5+9yqw0J0b4V/16nv+fPc1YKUnI/eMhD1r8kd/r1fVXhZ4Qr
	FZVYijMSDbWYi4oTAZQ6UWFnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0fe9a97..954155b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1160,7 +1160,7 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
 			struct page *page = pvec.pages[i];
 
 			/* until radix tree lookup accepts end_index */
-			if (page->index > end)
+			if (unlikely(page->index > end))
 				continue;
 
 			if (ino && ino_of_node(page) == ino) {
-- 
1.7.9.5

