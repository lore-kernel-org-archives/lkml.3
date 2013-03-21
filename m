Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3CUSkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:40:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40484 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3CUSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:40:38 -0400
Date: Thu, 21 Mar 2013 11:40:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: Russ Anderson <rja@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
In-Reply-To: <20130321105516.GC18484@gmail.com>
Message-ID: <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
References: <20130318155619.GA18828@sgi.com> <20130321105516.GC18484@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Ingo Molnar wrote:

> > Index: linux/mm/page_alloc.c
> > ===================================================================
> > --- linux.orig/mm/page_alloc.c	2013-03-18 10:52:11.510988843 -0500
> > +++ linux/mm/page_alloc.c	2013-03-18 10:52:14.214931348 -0500
> > @@ -4161,10 +4161,19 @@ int __meminit __early_pfn_to_nid(unsigne
> >  {
> >  	unsigned long start_pfn, end_pfn;
> >  	int i, nid;
> > +	static unsigned long last_start_pfn, last_end_pfn;
> > +	static int last_nid;
> 
> Please move these globals out of function local scope, to make it more 
> apparent that they are not on-stack. I only noticed it in the second pass.
> 

The way they're currently defined places these in meminit.data as 
appropriate; if they are moved out, please make sure to annotate their 
definitions with __meminitdata.
