Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaAaVTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:19:48 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60128 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:19:46 -0500
Date: Fri, 31 Jan 2014 13:19:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: dormando <dormando@rydia.net>
cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: kmem_cache_alloc panic in 3.10+
In-Reply-To: <alpine.DEB.2.10.1401301951060.5516@dinf>
Message-ID: <alpine.DEB.2.02.1401311315110.27318@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1401180036020.18419@dinf> <1390062576.31367.519.camel@edumazet-glaptop2.roam.corp.google.com> <alpine.DEB.2.02.1401181101220.579@dtop> <alpine.DEB.2.02.1401292301070.5905@dtop> <1391134615.28432.83.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAADnVQ+vCikFY-te2U8wD+ustNW-o6Cqs8ye5ZfyNcU6vPQzNA@mail.gmail.com> <alpine.DEB.2.10.1401301951060.5516@dinf>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, dormando wrote:

> > > I really wonder... it looks like a possible in SLUB. (might be already
> > > fixed)
> > >
> > > Could you try using SLAB instead ?
> >
> > try config_slub_debug_on=y ? it should catch double free and other things.
> >
> 
> Any slowdowns/issues with that?

CONFIG_SLUB_DEBUG_ON will definitely be slower but can help to identify 
any possible corruption issues.

I'm wondering if you have CONFIG_MEMCG enabled and are actually allocating 
slab in a non-root memcg?  What does /proc/self/cgroup say?
