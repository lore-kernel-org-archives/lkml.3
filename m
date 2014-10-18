Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaJRSXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 14:23:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaJRSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 14:23:39 -0400
Date: Sat, 18 Oct 2014 14:23:35 -0400 (EDT)
Message-Id: <20141018.142335.1935310766779155342.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141018.135907.356113264227709132.davem@davemloft.net>
References: <20141016.165017.1151349565275102498.davem@davemloft.net>
	<alpine.LRH.2.11.1410171410210.25429@adalberg.ut.ee>
	<20141018.135907.356113264227709132.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Oct 2014 11:23:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 18 Oct 2014 13:59:07 -0400 (EDT)

> I don't want to define the array size of the fpregs save area
> explicitly and thereby placing an artificial limit there.

Nevermind, it seems we have a hard limit of 7 FPU save areas anyways.

Meelis, please try this patch:

diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index f85dc85..cc6275c 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -63,7 +63,8 @@ struct thread_info {
 	struct pt_regs		*kern_una_regs;
 	unsigned int		kern_una_insn;
 
-	unsigned long		fpregs[0] __attribute__ ((aligned(64)));
+	unsigned long		fpregs[(7 * 256) / sizeof(unsigned long)]
+		__attribute__ ((aligned(64)));
 };
 
 #endif /* !(__ASSEMBLY__) */

