Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaBSPyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:54:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33623 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaBSPyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:54:40 -0500
Date: Wed, 19 Feb 2014 16:54:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: x86 perf's dTLB-load-misses broken on IvyBridge? II
Message-ID: <20140219155432.GN15586@twins.programming.kicks-ass.net>
References: <5303E8BF.9030107@linux.intel.com>
 <20140219154036.GX12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219154036.GX12219@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 07:40:36AM -0800, Andi Kleen wrote:
> > >  [ C(DTLB) ] = {
> > >         [ C(OP_READ) ] = {
> > >                 [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
> > >                 [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> > >         },
> 
> 
> Actually I tested on the wrong system earlier, sorry The miss event code 
> is wrong on IvyBridge, it should be 0x8108 (DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK),
> not 0x0108.

Ah indeed, that is different between snb and ivb.
