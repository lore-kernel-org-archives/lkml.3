Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3CRXo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:44:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39655 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753680Ab3CRXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:44:26 -0400
Message-ID: <1363650265.1932.17.camel@joe-AO722>
Subject: Re: [PATCH 1/3] rbtree_test: use pr_info for module prefix in
 messages
From: Joe Perches <joe@perches.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 16:44:25 -0700
In-Reply-To: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
References: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 16:20 -0700, Davidlohr Bueso wrote:
> This provides nicer message output. Since it seems more appropriate
> for the nature of this module, also use KERN_INFO instead of other
> levels.
[]
> diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
[]
> @@ -153,7 +156,7 @@ static int rbtree_test_init(void)
>  	int i, j;
>  	cycles_t time1, time2, time;
>  
> -	printk(KERN_ALERT "rbtree testing");
> +	pr_info("rbtree testing");
>  
>  	prandom_seed_state(&rnd, 3141592653589793238ULL);
>  	init();
> @@ -171,7 +174,7 @@ static int rbtree_test_init(void)
>  	time = time2 - time1;
>  
>  	time = div_u64(time, PERF_LOOPS);
> -	printk(" -> %llu cycles\n", (unsigned long long)time);
> +	pr_info(" -> %llu cycles\n", (unsigned long long)time);

You change the output here by more than just adding a prefix.

The first printk didn't have a newline.

The old code would print:

"rbtree testing -> <foo> cycles"

The new code prints:

"rbtree_test: rbtree testing"
"rbtree_test: -> <foo> cycles"

btw: each pr_info should have a newline termination
or be followed by a some number of pr_cont/printk with
the last one having a terminating newline.

The first pr_info here doesn't have a newline
so it's possible (though unlikely) that another
thread could have its output appended/interleaved
on the same line.


