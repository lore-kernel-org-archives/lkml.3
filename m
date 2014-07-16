Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbaGPNsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:48:06 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:48187 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaGPNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:48:03 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 16 Jul 2014 09:53:08 -0400 (EDT)
To: Andi Kleen <ak@linux.intel.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch] perf: use proper dTLB-load-misses event on Ivybridge
In-Reply-To: <20140714195259.GD5803@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1407160951380.22286@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu> <20140714195259.GD5803@tassilo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Andi Kleen wrote:

> On Mon, Jul 14, 2014 at 03:33:25PM -0400, Vince Weaver wrote:
> > 
> > This was discussed back in February 
> > 	https://lkml.org/lkml/2014/2/18/956
> > But I never saw a patch come out of it.
> > 
> > On Ivybridge we share the Sandybridge cache event tables, but the
> > dTLB-load-miss event is not compatible.  Patch it up after
> > the fact to the proper DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK
> 
> There is much more wrong. I've been working on revamping the whole
> tables.

any ETA on that?

The whole concept of generic events making life easier for casual users 
goes out the window if we're going to let them run experiments with bogus 
events.

If the IVB events are wrong we should just zero them out and give ENOENT 
for the entire lot of them rather than pretend like the kernel has useful 
event definitions.

Vince
