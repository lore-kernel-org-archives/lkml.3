Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3EDGe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 02:34:26 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51449 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3EDGeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 02:34:24 -0400
Date: Sat, 4 May 2013 08:34:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 2/3] perf, x86, lbr: Fix LBR filter
Message-ID: <20130504063420.GA14614@gmail.com>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.158211806@chello.nl>
 <20130503143411.GO19487@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503143411.GO19487@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > +	} else {
> > +		/*
> > +		 * The LBR logs any address in the IP, even if the IP just
> > +		 * faulted. This means userspace can control the from address.
> > +		 * Ensure we don't blindy read any address by validating it is
> > +		 * a known text address.
> > +		 */
> > +		if (kernel_text_address(from))
> 
> Sorry doing it this way is just incredible expensive and dumb.

If anyone using this feature notices the __module_address() overhead then 
a 'module addresses RCU rbtree' could be added, which should solve the 
overhead impact.

In any case Peter's patch fixes the bug without regressing the feature as 
it is implemented today. Do you have a better solution that does not break 
the ABI? The solution you proposed before regresses existing 
functionality.

Thanks,

	Ingo
