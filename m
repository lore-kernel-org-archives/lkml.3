Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbaISTPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:15:48 -0400
Received: from www.sr71.net ([198.145.64.142]:55369 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbaISTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:15:47 -0400
Message-ID: <541C80E1.9040601@sr71.net>
Date: Fri, 19 Sep 2014 12:15:45 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [RFC][PATCH 6/6] sched: consolidate config options
References: <20140917223310.026BCC2C@viggo.jf.intel.com> <20140917223320.2FF9CF11@viggo.jf.intel.com> <20140918172944.GT2840@worktop.localdomain>
In-Reply-To: <20140918172944.GT2840@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 10:29 AM, Peter Zijlstra wrote:
>> > +config SCHED_BOOK
>> > +	def_bool y
>> > +	prompt "Book scheduler support"
>> > +	depends on ARCH_ENABLE_SCHED_BOOK
>> > +	select SCHED_MC
>> > +	help
>> > +	  Book scheduler support improves the CPU scheduler's decision making
>> > +	  when dealing with machines that have several books.
>> > +
>> > +	  Currenltly only used on s390 which has only a single NUMA node.
>> > +	  Books are collections of CPUs that are grouped similarly to a NUMA
>> > +	  node, but without the same memory properites that NUMA nodes have.
> Nothing outside of s390 knows about SCHED_BOOK, it doesn't make sense to
> have that here.

By sticking all of them together, my hope was that folks who were going
to add a topology level could see all of the existing options in a
single place.

But, just say the word and I'll yank it out and repost.
