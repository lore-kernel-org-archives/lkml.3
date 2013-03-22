Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3CVHZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:25:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37491 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3CVHZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:25:37 -0400
Date: Fri, 22 Mar 2013 08:25:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Russ Anderson <rja@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130322072532.GC10608@gmail.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Thu, 21 Mar 2013, Ingo Molnar wrote:
> 
> > > Index: linux/mm/page_alloc.c
> > > ===================================================================
> > > --- linux.orig/mm/page_alloc.c	2013-03-18 10:52:11.510988843 -0500
> > > +++ linux/mm/page_alloc.c	2013-03-18 10:52:14.214931348 -0500
> > > @@ -4161,10 +4161,19 @@ int __meminit __early_pfn_to_nid(unsigne
> > >  {
> > >  	unsigned long start_pfn, end_pfn;
> > >  	int i, nid;
> > > +	static unsigned long last_start_pfn, last_end_pfn;
> > > +	static int last_nid;
> > 
> > Please move these globals out of function local scope, to make it more 
> > apparent that they are not on-stack. I only noticed it in the second pass.
> 
> The way they're currently defined places these in meminit.data as 
> appropriate; if they are moved out, please make sure to annotate their 
> definitions with __meminitdata.

I'm fine with having them within the function as well in this special 
case, as long as a heavy /* NOTE: ... */ warning is put before them - 
which explains why these SMP-unsafe globals are safe.

( That warning will also act as a visual delimiter that breaks the 
  normally confusing and misleading 'globals mixed amongst stack 
  variables' pattern. )

Thanks,

	Ingo
