Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767Ab3GSPwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:52:09 -0400
Received: from www.sr71.net ([198.145.64.142]:42924 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3GSPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:52:07 -0400
Message-ID: <51E9609D.4030201@sr71.net>
Date: Fri, 19 Jul 2013 08:51:57 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
References: <20130716234438.C792C316@viggo.jf.intel.com> <20130717072100.GA14359@gmail.com> <20130718135157.2262e28b2c6e0f43a4d0fe7a@linux-foundation.org> <20130719082848.GA25784@gmail.com>
In-Reply-To: <20130719082848.GA25784@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 01:28 AM, Ingo Molnar wrote:
> UP is slowly going extinct, but in any case these counters ought to inform 
> us about TLB flushes even on UP systems:
> 
>>>> > > > +		NR_TLB_LOCAL_FLUSH_ALL,
>>>> > > > +		NR_TLB_LOCAL_FLUSH_ONE,
>>>> > > > +		NR_TLB_LOCAL_FLUSH_ONE_KERNEL,
> While these ought to be compiled out on UP kernels:
> 
>>>> > > > +		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
>>>> > > > +		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
> Right?

Yeah, it's useful on UP too.  But I realized that my changes were
confined to the SMP code.  The UP code is almost all in one of the
headers, and I didn't touch it.  So I've got some work there to fix it up.

