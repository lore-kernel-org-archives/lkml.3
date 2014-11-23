Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaKWT0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:26:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50248 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaKWT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:26:16 -0500
Date: Sun, 23 Nov 2014 19:26:13 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        mingo@kernel.org, tj@kernel.org, matt.fleming@intel.com,
        will.auld@intel.com, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
Message-ID: <20141123192613.GA2956@console-pimps.org>
References: <alpine.DEB.2.11.1411211224070.6439@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411211224070.6439@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov, at 03:19:52PM, Thomas Gleixner wrote:
> > +		barrier();
> > +		cqe_genable = true;
> 
> What's the exact point of that barrier?
 
Yes, this definitely needs documenting. Vikas?

> > +
> > +/*
> > + * Tests if only contiguous bits are set.
> > + */
> > +
> > +static inline bool cbm_iscontiguous(unsigned long var)
> > +{
> 
> This one here can be implemented with existing bitmap functions as
> well.

Something like this?

	first_bit = find_next_bit(map, nr_bits, -1);
	zero_bit = find_next_zero_bit(map, nr_bits, first_bit);

	if (find_next_bit(map, nr_bits, zero_bit) < nr_bits)
		return -EINVAL;	/* non-contiguous bits */

-- 
Matt Fleming, Intel Open Source Technology Center
