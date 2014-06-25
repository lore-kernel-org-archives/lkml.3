Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaFYWct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:32:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaFYWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:32:47 -0400
Date: Wed, 25 Jun 2014 15:32:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] lib: list_sort: Various minor improvements
Message-Id: <20140625153246.3d3dbda781ce1af5524269ab@linux-foundation.org>
In-Reply-To: <87egycoc8t.fsf@rasmusvillemoes.dk>
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140625145314.3e16af6998765b7aad860bf7@linux-foundation.org>
	<87egycoc8t.fsf@rasmusvillemoes.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 00:28:18 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> > We may as well do the pr_foo() conversion as well.  As often happens,
> > the results are quite pleasing.
> >
> > --- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo
> > +++ a/lib/list_sort.c
> > @@ -1,3 +1,6 @@
> > +
> > +#define pr_fmt(fmt) "list_sort_test: " fmt
> > +
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/list_sort.h>
> > @@ -125,9 +128,8 @@ void list_sort(void *priv, struct list_h
> >  		}
> >  		if (lev > max_lev) {
> >  			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
> > -				printk_once(KERN_DEBUG "list passed to"
> > -					" list_sort() too long for"
> > -					" efficiency\n");
> > +				pr_debug_once("list passed to list_sort() too "
> > +					      "long for efficiency\n");
> 
> Minor comment: Won't this end up saying "list_sort_test: list passed to
> ...", despite the list coming from a 'real' user? Maybe change the first
> #define to '"list_sort: " fmt', the above message to "passed list too
> long for efficiency", and redefine pr_fmt right after #ifdef
> CONFIG_TEST_LIST_SORT.

Yeah, I was hoping nobody would notice that ;)

How about just

		printk_once(KERN_DEBUG "list too long for efficiency\n");


