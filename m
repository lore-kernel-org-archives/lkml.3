Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbaLKNfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:35:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaLKNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:35:44 -0500
Date: Thu, 11 Dec 2014 14:35:18 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        brouer@redhat.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
Message-ID: <20141211143518.02c781ee@redhat.com>
In-Reply-To: <20141210163017.092096069@linux.com>
References: <20141210163017.092096069@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 10:30:17 -0600
Christoph Lameter <cl@linux.com> wrote:

[...]
> 
> Slab Benchmarks on a kernel with CONFIG_PREEMPT show an improvement of
> 20%-50% of fastpath latency:
> 
> Before:
> 
> Single thread testing
[...]
> 2. Kmalloc: alloc/free test
[...]
> 10000 times kmalloc(256)/kfree -> 116 cycles
[...]
> 
> 
> After:
> 
> Single thread testing
[...]
> 2. Kmalloc: alloc/free test
[...]
> 10000 times kmalloc(256)/kfree -> 60 cycles
[...]

It looks like an impressive saving 116 -> 60 cycles.  I just don't see
the same kind of improvements with my similar tests[1][2].

My test[1] is just a fast-path loop over kmem_cache_alloc+free on
256bytes objects. (Results after explicitly inlining new func
is_pointer_to_page())

 baseline: 47 cycles(tsc) 19.032 ns
 patchset: 45 cycles(tsc) 18.135 ns

I do see the improvement, but it is not as high as I would have expected.

(CPU E5-2695)

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_kmem_cache1.c
[2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/qmempool_bench.c

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
