Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbaLPDFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:05:47 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:51141 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863AbaLPDFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:05:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03006;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=7;RT=7;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Dave Jones" <davej@redhat.com>, "Mike Galbraith" <mgalbraith@suse.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>, "'Chris Mason'" <clm@fb.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Date: Tue, 16 Dec 2014 11:04:51 +0800
Message-ID: <02fc01d018dd$0fc01530$2f403f90$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAY2zOzFeUU6BzyRl2NKDnRxAvX/Q==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But me not seeing any other bug clearly doesn't mean it doesn't exist.
> 
Perhaps  we can easy the zap loop if it is busy.

thanks
Hillf

--- a/mm/memory.c	Tue Dec 16 10:38:03 2014
+++ b/mm/memory.c	Tue Dec 16 10:42:07 2014
@@ -1212,8 +1212,10 @@ again:
 		force_flush = 0;
 		tlb_flush_mmu_free(tlb);
 
-		if (addr != end)
+		if (addr != end) {
+			cond_resched();
 			goto again;
+		}
 	}
 
 	return addr;
--


