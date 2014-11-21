Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaKUUnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:43:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:59432 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaKUUnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:43:37 -0500
Date: Fri, 21 Nov 2014 21:43:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        mingo@kernel.org, tj@kernel.org, matt.flemming@intel.com,
        will.auld@intel.com, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <546FA0C4.1000402@intel.com>
Message-ID: <alpine.DEB.2.11.1411212139360.6439@nanos>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com> <546FA0C4.1000402@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Dave Hansen wrote:
> On 11/19/2014 05:05 PM, Vikas Shivappa wrote:
> > +	/*
> > +	 * Hard code the checks and values for HSW SKUs.
> > +	 * Unfortunately! have to check against only these brand name strings.
> > +	 */
> > +
> > +	for (i = 0; i < 5; i++)
> > +		if (!strcmp(hsw_brandstrs[i], c->x86_model_id)) {
> > +			c->x86_cqe_closs = 4;
> > +			c->x86_cqe_cbmlength = 20;
> > +			return true;
> > +		}
> 
> Please use ARRAY_SIZE() here.  Otherwise, I guarantee the next string
> you add to hsw_brandstrs[] gets silently ignored.
> 
> Are there really only 5 CPUs?  This:
> 
> > http://ark.intel.com/products/family/78583/Intel-Xeon-Processor-E5-v3-Family#@Server
> 
> lists 32 skus.

We really should find a proper software probing solution for this
instead of having a gazillion of brand strings plus micro code version
checks around for this.

Why cant the HW folks release a micro code version which fixes the
obviously wreckaged CPUID enumeration of this feature instead of
burdening us with that horror?

Can you please find a proper sized clue bat and whack your HW folks
over the head for this insanity?

Thanks,

	tglx
