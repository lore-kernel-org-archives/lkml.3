Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbaISPNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:13:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:41859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaISPKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:10 -0400
Date: Thu, 18 Sep 2014 19:29:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [RFC][PATCH 6/6] sched: consolidate config options
Message-ID: <20140918172944.GT2840@worktop.localdomain>
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
 <20140917223320.2FF9CF11@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917223320.2FF9CF11@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:33:20PM -0700, Dave Hansen wrote:
> diff -puN /dev/null kernel/sched/Kconfig
> --- /dev/null	2014-04-10 11:28:14.066815724 -0700
> +++ b/kernel/sched/Kconfig	2014-09-17 15:28:58.620622789 -0700
> @@ -0,0 +1,42 @@
> +config ARCH_ENABLE_SCHED_MC
> +	depends on SMP
> +	def_bool n
> +
> +config ARCH_ENABLE_SCHED_BOOK
> +	depends on SMP
> +	def_bool n
> +
> +config ARCH_ENABLE_SCHED_SMT
> +	depends on SMP
> +	def_bool n
> +
> +config SCHED_MC
> +	bool "Multi-core scheduler support"
> +	default n if s390
> +	default y
> +	depends on ARCH_ENABLE_SCHED_MC
> +	help
> +	  Multi-core scheduler support improves the CPU scheduler's decision
> +	  making when dealing with multi-core CPU chips at a cost of slightly
> +	  increased overhead in some places. If unsure say N here.
> +
> +config SCHED_BOOK
> +	def_bool y
> +	prompt "Book scheduler support"
> +	depends on ARCH_ENABLE_SCHED_BOOK
> +	select SCHED_MC
> +	help
> +	  Book scheduler support improves the CPU scheduler's decision making
> +	  when dealing with machines that have several books.
> +
> +	  Currenltly only used on s390 which has only a single NUMA node.
> +	  Books are collections of CPUs that are grouped similarly to a NUMA
> +	  node, but without the same memory properites that NUMA nodes have.

Nothing outside of s390 knows about SCHED_BOOK, it doesn't make sense to
have that here.

> +config SCHED_SMT
> +	bool "SMT scheduler support"
> +	depends on ARCH_ENABLE_SCHED_SMT
> +	help
> +	  Improves the CPU scheduler's decision making when dealing with
> +	  MultiThreading at a cost of slightly increased overhead in some
> +	  places. If unsure say N here.
> _
