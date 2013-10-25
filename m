Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab3JYFfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:35:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37999 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3JYFfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:35:40 -0400
X-AuditID: cbfee691-b7f866d000001b8c-9d-526a032afbc5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: add tracepoint for vm_page_mkwrite
Date: Fri, 25 Oct 2013 14:34:59 +0900
Message-id: <1382679299-18250-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1382679299-18250-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1382679299-18250-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA10t5qwgg3nduhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZeyZzF/wmKOib89P
	5gbG1exdjJwcEgImEld3tDJC2GISF+6tZ+ti5OIQEljGKNH97T9LFyMHWNH+uyEQ8UWMEmsm
	9TBDOM1MEgteLGAEKWIT0JbYvN8AZJCIALPEgqnnGUFqmAUmMEr8X/SeBSQhLGAr0ffhMZjN
	IqAqsffsf7AreAXcJV537oa6Qlti2/OJYDangIfE0edbWUFsIaCazva3YEMlBL6zSWxd/YoZ
	YpCAxLfJh6AulZXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRESsBN3MN4/YH2IMRlo3ERmKdHkfGDA55XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDo4ZBBp+0SbjR9pPzrtd71gdt6NSoXrHj3/fK265XTLru
	z085ei/PxObpitO97uan78/uvfpBZ6XDVKXHdl/01jalvcr/cWG90xYHn8UmDCv/eM85NeW6
	Ac/xOxo2mqFfg1l2O1845+YsnbDt2BuLye07FkSKJvmYRVoHT62desi1fgfH6yV9lUosxRmJ
	hlrMRcWJALqwzJluAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV0t5qwgg1lLNS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zYM5m/4DFHRd+en8wNjKvZuxg5OCQETCT23w3pYuQEMsUkLtxbz9bFyMUh
	JLCIUWLNpB5mCKeZSWLBiwWMIA1sAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgK2
	En0fHoPZLAKqEnvP/mcHsXkF3CVed+5mhNimLbHt+UQwm1PAQ+Lo862sILYQUE1n+1vGCYy8
	CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx8MzqR2MKxssDjEKcDAq8fAmzMgMEmJN
	LCuuzD3EKMHBrCTCW3MaKMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wFjNK4k3NDYxM7I0
	MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGztkX5fO7jhl2Pz4+dd63qzum
	fpk5/+kcWWtNZtG5Xw7+fGb0PvdAxlOvWKOm0lh2xS+bgjUvNt70v5XS1KGscv+10GvTJ8+7
	dcuuqGS8dJZhYXrPsu7/6efp64KXbDDKm5S5bqkcm/v5QwyG3iKlaeGLpKOeC+a/vOrp7bar
	ofW8hUXIjAeRSizFGYmGWsxFxYkAeA2prMsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_vm_page_mkwrite.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c              | 1 +
 include/trace/events/f2fs.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c80faa2..2d4190a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -88,6 +88,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
+	trace_f2fs_vm_page_mkwrite(page, DATA);
 mapped:
 	/* fill the page */
 	wait_on_page_writeback(page);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ebde3af..e0dc355 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -667,6 +667,13 @@ DEFINE_EVENT(f2fs__page, f2fs_set_page_dirty,
 	TP_ARGS(page, type)
 );
 
+DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
 TRACE_EVENT(f2fs_submit_write_page,
 
 	TP_PROTO(struct page *page, block_t blk_addr, int type),
-- 
1.8.4.474.g128a96c

