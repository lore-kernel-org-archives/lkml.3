Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbaISPKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:10:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaISPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:09 -0400
Date: Thu, 18 Sep 2014 22:49:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
Message-ID: <20140918204906.GM2848@worktop.localdomain>
References: <20140918193334.C065EBCE@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918193334.C065EBCE@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:33:34PM -0700, Dave Hansen wrote:
> 
> 
> This is my third attempt to fix this.  It's definitely simpler
> than the previous set.  This takes Peter Z's suggestion to just
> create and use a different topology when we see these
> "Cluster-on-Die" systems.


> +static struct sched_domain_topology_level numa_inside_package_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> +#endif
> +	{ NULL, },
> +};

Yes, that looks ok. The only thing is that we need to fix the MC and DIE
masks. But I can do that in a separate patch. This should ideally still
contain the MC domain (as in LLC) mask, just not the DIE domain (as in
pkg).

But as you already saw, bits are somewhat icky atm.
