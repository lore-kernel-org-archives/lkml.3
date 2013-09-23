Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3IWJhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3IWJhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:37:02 -0400
Date: Mon, 23 Sep 2013 11:36:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf callchain: Convert children list to rbtree
Message-ID: <20130923093645.GA1025@krava.brq.redhat.com>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
 <1378801458-2515-2-git-send-email-namhyung@kernel.org>
 <20130922111559.GC1036@krava.brq.redhat.com>
 <87zjr3q42c.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjr3q42c.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:29:15PM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Sun, 22 Sep 2013 13:15:59 +0200, Jiri Olsa wrote:
> > On Tue, Sep 10, 2013 at 05:24:16PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >
> > SNIP
> >
> >> index 2b585bc308cf..1b22b6269213 100644
> >> --- a/tools/perf/util/callchain.h
> >> +++ b/tools/perf/util/callchain.h
> >> @@ -21,10 +21,9 @@ enum chain_order {
> >>  
> >>  struct callchain_node {
> >>  	struct callchain_node	*parent;
> >> -	struct list_head	siblings;
> >> -	struct list_head	children;
> >>  	struct list_head	val;
> >>  	struct rb_node		rb_node; /* to sort nodes in an rbtree */
> >> +	struct rb_root		rb_root_in; /* sorted tree of children */
> >>  	struct rb_root		rb_root; /* sorted tree of children */
> >>  	unsigned int		val_nr;
> >>  	u64			hit;
> >> @@ -86,8 +85,6 @@ extern __thread struct callchain_cursor callchain_cursor;
> >>  
> >>  static inline void callchain_init(struct callchain_root *root)
> >>  {
> >> -	INIT_LIST_HEAD(&root->node.siblings);
> >> -	INIT_LIST_HEAD(&root->node.children);
> >>  	INIT_LIST_HEAD(&root->node.val);
> >
> > don't we miss rb_root_in init here, like:
> >
> > 	root->node.rb_root_in = RB_ROOT;
> 
> The struct callchain_root in hist entry initialized to zero so
> technically it doesn't need to be set.  But I think it's better to have
> explicit initializer.

yep, I was writing some tests for this when I noticed that,
having callchain_root defined on stack

jirka
