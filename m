Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaIPGoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:44:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35833 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIPGoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:44:08 -0400
Date: Tue, 16 Sep 2014 08:44:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916064403.GC14807@gmail.com>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <20140916013845.390833b9@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916013845.390833b9@as>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert.lkml@gmail.com> wrote:

> On Tue, 16 Sep 2014 05:29:20 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, Sep 15, 2014 at 03:26:41PM -0700, Dave Hansen wrote:
> > > 
> > > I'm getting the spew below when booting with Haswell (Xeon 
> > > E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature 
> > > enabled in the BIOS.
> > 
> > What is that cluster-on-die thing? I've heard it before but 
> > never could find anything on it.
> 
> Each CPU has 2.5MB of L3 connected together in a ring that 
> makes it all act like a single shared cache. The HW tries to 
> place the data so it's closest to the CPU that uses it. On the 
> larger processors there are two rings with an interconnect 
> between them that adds latency if a cache fetch has to cross 
> that. CoD breaks that connection and effectively gives you two 
> nodes on one die.

Note that that's not really a 'NUMA node' in the way lots of 
places in the kernel assume it: permanent placement assymetry 
(and access cost assymetry) of RAM.

It's a new topology construct that needs new handling (and 
probably a new mask): Non Uniform Cache Architecture (NUCA)
or so.

Thanks,

	Ingo
