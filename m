Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBNGFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:05:55 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57694 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaBNGFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:05:54 -0500
X-Nat-Received: from [202.181.97.72]:61509 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1392357941.28680
Message-Id: <201402140605.s1E65fBl044127@www262.sakura.ne.jp>
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: hannes@cmpxchg.org
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Feb 2014 15:05:41 +0900
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org> <201402130321.s1D3LH41073563@www262.sakura.ne.jp> <20140213221126.GP6963@cmpxchg.org> <20140213142407.f2c41f5c6561e708f2453e93@linux-foundation.org> <20140214112935.4df6f8ace56725331614556a@canb.auug.org.au>
In-Reply-To: <20140214112935.4df6f8ace56725331614556a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14022014 #7427480, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Thanks for the report.  There is already a fix for this in -mm:
> http://marc.info/?l=linux-mm-commits&m=139180637114625&w=2
> 
> It was merged on the 7th, so it should show up in -next... any day
> now?

That patch solved this bproblem but breaks build instead.

  ERROR: \"list_lru_init_key\" [fs/xfs/xfs.ko] undefined!
  ERROR: \"list_lru_init_key\" [fs/gfs2/gfs2.ko] undefined!
  make[1]: *** [__modpost] Error 1

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 2a5b8fd..f1a0db1 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -143,7 +143,7 @@ int list_lru_init_key(struct list_lru *lru, struct lock_class_key *key)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(list_lru_init);
+EXPORT_SYMBOL_GPL(list_lru_init_key);
 
 void list_lru_destroy(struct list_lru *lru)
 {

