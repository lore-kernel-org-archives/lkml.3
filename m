Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaJNVTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:19:41 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45936 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaJNVTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:19:40 -0400
Date: Wed, 15 Oct 2014 00:19:36 +0300 (EEST)
From: mroos@linux.ee
To: David Miller <davem@davemloft.net>
cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141013.200416.641735303627599182.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee>
References: <20141012.132012.254712930139255731.davem@davemloft.net> <alpine.LRH.2.11.1410132320110.9586@adalberg.ut.ee> <20141013235219.GA11191@js1304-P5Q-DELUXE> <20141013.200416.641735303627599182.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'd like to know that your another problem is related to commit
> > bf0dea23a9c0 ("mm/slab: use percpu allocator for cpu cache").  So,
> > if the commit is reverted, your another problem is also gone
> > completely?
> 
> The other problem has been present forever.

Umm? I am afraid I have been describing it badly. This random 
SIGBUS+SIGSEGV problem is new - I have not seen it before.

I have been able to do kernel compiles for years on sparc64 (modulo 
specific bugs in specific configurations) and 3.17 + start/end swap 
patch seems also stable for most machine. With yesterdays git + align 
patch, it dies with SIGBUS multiple times during compilation so it's a 
new regression for me.

Will try reverting that commit tomorrow.

My only other current sparc64 problems that I am seeing - V210/V440 die 
during bootup if compiled with gcc 4.9 and V480 dies with FATAL 
exceptions during bootups since previous kernel release. Maybe also 
exit_mmap warning - I do not know if they have been fixed, I see them 
rarely.

-- 
Meelis Roos (mroos@linux.ee)
