Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3BDBhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:37:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17218 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3BDBhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:37:32 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-43-510f10dab29a
Message-id: <1359941761.2739.39.camel@lcm>
Subject: Re: [PATCH 2/6] f2fs: move out f2fs_balance_fs from gc_thread_func
From: Changman Lee <cm224.lee@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 04 Feb 2013 10:36:01 +0900
In-reply-to: <1359816733-16286-1-git-send-email-linkinjeon@gmail.com>
References: <1359816733-16286-1-git-send-email-linkinjeon@gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zfd1bAvyBBotnmlrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU8XsJV0MBT8W7OftYGxnOcXYycHBICJhK3569gg7DF
	JC7cWw9kc3EICSxjlHi4eg6QwwFWNH+DHkiNkMAiRonJj6Uhal4zSkzbcJgFJMEroCXx4ulm
	sEHCAt4SLVu3MYHYbEDx9tNrWUDmiAioSUx4lgrSyyxwmVHi8/RDYPUsAqoSq5a2gtmcAq4S
	7+Z9YAepFxJwkTjayQESZhZQl5g0bxEzxJ1KErvbO9kh4vISm9e8ZYY4QVDix+R7LCDzJQS6
	2SV6rj9ghpgvIPFt8iEWiF9kJTYdgJojKXFwxQ2WCYxis5CsmIVk7CwkYxcwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECIkL6R2MqxosDjEKcDAq8fAy/OILFGJNLCuuzD3EKMHBrCTC
	e9UIKMSbklhZlVqUH19UmpNafIgxGejAicxSosn5wJjNK4k3NDY2MTMxNTG3NDU3JU1YSZyX
	8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MLpwqN0Wkek3Oiwu8+XDl9vtZm1VtXisvSH25eG55
	eDJHr62rQ6S+7V6J/M4P/x2d3DdseZymLRplFB2//JGQ2G6f9qd8593yc3gOem5dZnxrq+3N
	xONXJFtLW/rqTJS/cxffeuH2IXSbt62T5maukvYX5y8v2vQx7PcH/5taOqkOQZa/Et4rsRRn
	JBpqMRcVJwIAQbrBn88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd1bAvyBBi/m6Fvs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmPF7CVdDAU/Fu
	zn7WBsZznF2MHBwSAiYS8zfodTFyApliEhfurWcDsYUEFjFKTH4s3cXIBWS/ZpSYtuEwC0iC
	V0BL4sXTzWBFwgLeEi1btzGB2GxA8fbTa1lAZooIqElMeJYK0ssscJlR4vP0Q2D1LAKqEquW
	toLZnAKuEu/mfWAHqRcScJE42skBEmYWUJeYNG8RM8Q9ShK72zvZIeLyEpvXvGWGOEFQ4sfk
	eywTGAVmIWmZhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+6Z9A7GVQ0W
	hxgFOBiVeHgZfvEFCrEmlhVX5h5ilOBgVhLhvWoEFOJNSaysSi3Kjy8qzUktPsSYDPTQRGYp
	0eR8YELIK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MFr/S
	/1m5yH9cuHBazbJ7kn9/bQwNnRbseL3LWdoxZ3XUhIedRXvC7arZHz/V5vzf5tn5pDfXaJv4
	gde2LL7y60VqLGsTfHd7aZi0MSzffJdNIfPcjtX/Ny4Sna9vtedRsbeim9qCx893u+hM9t7x
	o4YpuYLzbfD2vGCe8+nf1mbbal9mD6hVYinOSDTUYi4qTgQAAr456f4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you know, f2fs_balance_fs conducts gc if f2fs has not enough free
sections. But, the purpose of background gc is to conduct gc during idle
time without checking free sections so that f2fs can solve defragment
condition.

Could you review this?

--> 8 --

>From fbda3262dac81c4f0d7ae8b9b757c820da593120 Mon Sep 17 00:00:00 2001
From: Changman Lee <cm224.lee@samsung.com>
Date: Mon, 4 Feb 2013 10:05:09 +0900
Subject: [PATCH] f2fs: remove unnecessary gc option check and balance_fs

 1. If f2fs is mounted with background_gc_off option, checking
    BG_GC is not redundant.
 2. f2fs_balance_fs is checked in f2fs_gc, so this is also redundant.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 8fe43f3..e5c47f6 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -49,11 +49,6 @@ static int gc_thread_func(void *data)
 			continue;
 		}
 
-		f2fs_balance_fs(sbi);
-
-		if (!test_opt(sbi, BG_GC))
-			continue;
-
 		/*
 		 * [GC triggering condition]
 		 * 0. GC is not conducted currently.
@@ -96,6 +91,8 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_gc_kthread *gc_th;
 
+	if (!test_opt(sbi, BG_GC))
+		return 0;
 	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
 	if (!gc_th)
 		return -ENOMEM;
-- 
1.7.10.4



