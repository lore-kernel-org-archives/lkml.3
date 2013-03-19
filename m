Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab3CSROo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:14:44 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38091 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3CSROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:14:43 -0400
Message-ID: <1363713282.2781.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/3] rbtree_test: use pr_info for module prefix in
 messages
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 10:14:42 -0700
In-Reply-To: <CAKocOOOj80R2nP+B_k=jTS-UgA27VvMa-kAFiJbORZg4pKRS1Q@mail.gmail.com>
References: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
	 <CAKocOOOj80R2nP+B_k=jTS-UgA27VvMa-kAFiJbORZg4pKRS1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 10:29 -0600, Shuah Khan wrote:
> On Mon, Mar 18, 2013 at 5:20 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > This provides nicer message output. Since it seems more appropriate
> > for the nature of this module, also use KERN_INFO instead of other
> > levels.
> 
> Why are you changing the ALERTs to INFO?

Because of the nature of the messages. They don't justify having a
KERN_ALERT level (requiring immediate attention), and it seems a lot
more suitable to use INFO instead.

> 
> >
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > ---
> >  lib/rbtree_test.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
> > index af38aed..66ca26d 100644
> > --- a/lib/rbtree_test.c
> > +++ b/lib/rbtree_test.c
> > @@ -1,3 +1,6 @@
> > +#define KMSG_COMPONENT "rbtree_test"
> > +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> > +
> >  #include <linux/module.h>
> >  #include <linux/rbtree_augmented.h>
> >  #include <linux/random.h>
> > @@ -153,7 +156,7 @@ static int rbtree_test_init(void)
> >         int i, j;
> >         cycles_t time1, time2, time;
> >
> > -       printk(KERN_ALERT "rbtree testing");
> > +       pr_info("rbtree testing");
> 
> This is changing the output from KERN_ALERT to KERN_INFO. Why is this
> necessary? Should this be pr_alert() instead?
> 
> 
> >
> >         prandom_seed_state(&rnd, 3141592653589793238ULL);
> >         init();
> > @@ -171,7 +174,7 @@ static int rbtree_test_init(void)
> >         time = time2 - time1;
> >
> >         time = div_u64(time, PERF_LOOPS);
> > -       printk(" -> %llu cycles\n", (unsigned long long)time);
> > +       pr_info(" -> %llu cycles\n", (unsigned long long)time);
> >
> >         for (i = 0; i < CHECK_LOOPS; i++) {
> >                 init();
> > @@ -186,7 +189,7 @@ static int rbtree_test_init(void)
> >                 check(0);
> >         }
> >
> > -       printk(KERN_ALERT "augmented rbtree testing");
> > +       pr_info("augmented rbtree testing");
> 
> This is changing the output from KERN_ALERT to KERN_INFO. Why is this
> necessary? Should this be pr_alert() instead?
> 
> >
> >         init();
> >
> > @@ -203,7 +206,7 @@ static int rbtree_test_init(void)
> >         time = time2 - time1;
> >
> >         time = div_u64(time, PERF_LOOPS);
> > -       printk(" -> %llu cycles\n", (unsigned long long)time);
> > +       pr_info(" -> %llu cycles\n", (unsigned long long)time);
> >
> >         for (i = 0; i < CHECK_LOOPS; i++) {
> >                 init();
> > @@ -223,7 +226,7 @@ static int rbtree_test_init(void)
> >
> >  static void rbtree_test_exit(void)
> >  {
> > -       printk(KERN_ALERT "test exit\n");
> > +       pr_info("test exit\n");
> 
> This is changing the output from KERN_ALERT to KERN_INFO. Why is this
> necessary? Should this be pr_alert() instead?
> 
> >  }
> >
> >  module_init(rbtree_test_init)
> > --
> > 1.7.11.7
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


