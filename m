Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaFNQL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:11:56 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4454 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbaFNQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:11:54 -0400
X-IronPort-AV: E=Sophos;i="5.01,477,1400018400"; 
   d="scan'208";a="80067784"
Date: Sat, 14 Jun 2014 18:11:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle : Script to detect cast after memory
 allocation
In-Reply-To: <1402761961.2756.12.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406141809050.1962@localhost6.localdomain6>
References: <20140614154541.GA4179@himangi-Dell> <1402761961.2756.12.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2014, Joe Perches wrote:

> On Sat, 2014-06-14 at 21:15 +0530, Himangi Saraogi wrote:
> > This script detects cases of use of cast for the value returned by
> > kmalloc, kzalloc, kcalloc, kmem_cache_alloc, kmem_cache_zalloc,
> > kmem_cache_alloc_node, kmalloc_node and kzalloc_node and removes
> > the cast as it is not useful. This Coccinelle script replaces
> > drop_kmalloc_cast.cocci as it removes the casting in more limited
> > cases of kmalloc, kzalloc and kcalloc.
> 
> Perhaps make this more generic for any void *?
> 
> Something like:
> 
> @@
> void *t;
> type other;
> @@
> 
> -       (other *)t
> +       t

Himangi, could you try it and check that you get at least the results that 
you get with the current rule?  Because I'm not sure that Coccinelle would 
have the type information available to know what is the return type of eg
kmalloc.  Maybe you would need to give the option --recursive-includes.

Perhaps it would be reasonable to add this among the specific functions.  
That is, t could be part of the disjunctions.

julia
