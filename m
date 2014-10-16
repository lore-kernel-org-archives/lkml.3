Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaJPRs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:48:28 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61328 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaJPRs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:48:26 -0400
Message-ID: <1413481705.28798.32.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: =?ISO-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?ISO-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 16 Oct 2014 10:48:25 -0700
In-Reply-To: <20141016173401.GA16515@f1.synalogic.ca>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
	 <20141015215701.GA4109@f1.synalogic.ca>
	 <1413413127.17186.5.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141016173401.GA16515@f1.synalogic.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 10:34 -0700, Benjamin Poirier wrote:
> On 2014/10/15 15:45, Eric Dumazet wrote:

> >  kmap_atomic()/kunmap_atomic() is missing, so we lack
> > __cpuc_flush_dcache_area() operations.
> > 
> 
> You lost me there.
> 1) I don't see the link
> 2) It seems kmap_atomic and so on are there:
> $ grep kmap_atomic System.map-3.16-2-kirkwood
> c0014838 T kmap_atomic
> c001491c T kmap_atomic_pfn
> c00149a4 T kmap_atomic_to_page
> 
> MACH_KIRKWOOD selects CPU_FEROCEON which has
> __cpuc_flush_dcache_area ->
> 	cpu_cache.flush_kern_dcache_area ->
> 		feroceon_flush_kern_dcache_area

I meant to put a '?' instead of a '.'

Note that tcp does a copy, using :


