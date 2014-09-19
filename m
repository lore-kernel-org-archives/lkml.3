Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbaISXDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:03:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaISXDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:03:14 -0400
Date: Sat, 20 Sep 2014 01:03:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [RFC][PATCH 6/6] sched: consolidate config options
Message-ID: <20140919230308.GK2832@worktop.localdomain>
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
 <20140917223320.2FF9CF11@viggo.jf.intel.com>
 <20140918172944.GT2840@worktop.localdomain>
 <541C80E1.9040601@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541C80E1.9040601@sr71.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:15:45PM -0700, Dave Hansen wrote:
> On 09/18/2014 10:29 AM, Peter Zijlstra wrote:
> >> > +config SCHED_BOOK
> >> > +	def_bool y
> >> > +	prompt "Book scheduler support"
> >> > +	depends on ARCH_ENABLE_SCHED_BOOK
> >> > +	select SCHED_MC
> >> > +	help
> >> > +	  Book scheduler support improves the CPU scheduler's decision making
> >> > +	  when dealing with machines that have several books.
> >> > +
> >> > +	  Currenltly only used on s390 which has only a single NUMA node.
> >> > +	  Books are collections of CPUs that are grouped similarly to a NUMA
> >> > +	  node, but without the same memory properites that NUMA nodes have.
> > Nothing outside of s390 knows about SCHED_BOOK, it doesn't make sense to
> > have that here.
> 
> By sticking all of them together, my hope was that folks who were going
> to add a topology level could see all of the existing options in a
> single place.
> 
> But, just say the word and I'll yank it out and repost.

Yeah, I think its best to leave it a s390 private afair.
