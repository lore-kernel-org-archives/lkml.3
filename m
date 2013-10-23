Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3JWMpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab3JWMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:45:48 -0400
Date: Wed, 23 Oct 2013 10:45:22 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf callchain: Convert children list to rbtree
Message-ID: <20131023124521.GB3824@infradead.org>
References: <1381468543-25334-2-git-send-email-namhyung@kernel.org>
 <tip-e369517ce5f796945c6af047b4e8b1d650e03458@git.kernel.org>
 <20131023110723.GA2502@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023110723.GA2502@localhost.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 23, 2013 at 12:07:26PM +0100, Frederic Weisbecker escreveu:
> On Wed, Oct 23, 2013 at 12:54:48AM -0700, tip-bot for Namhyung Kim wrote:
> > -#define chain_for_each_child(child, parent)	\
> > -	list_for_each_entry(child, &parent->children, siblings)
> > -
> > -#define chain_for_each_child_safe(child, next, parent)	\
> > -	list_for_each_entry_safe(child, next, &parent->children, siblings)
> 
> We can probably keep these APIs using the rb root iteration code.
> 
> There should be an rb_node_for_each() anyway, and rb_node_for_each_entry(). People
> refused to have to have such an API because they feared it would encourage blind use
> of this O(n log n) iteration. There is plenty of such usecase in practice though, especially
> in perf. So I think we can now start to think about it for real.

I tried introducing one, PeterZ objected, on the grounds you mentioned,
and I still think they are needed, agree with you. Just put a:

/*
   DANGER WILL ROBINSON DANGER

   You should know what you're doing, PeterZ is watching you!

   I CAN NOT ACCEPT THAT PERSON ACTION
*/

or something like that above such helpers ;-)

- Arnaldo
