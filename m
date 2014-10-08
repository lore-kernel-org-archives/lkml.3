Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaJHUFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:05:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40697 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaJHUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:05:01 -0400
Date: Wed, 8 Oct 2014 21:04:58 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Message-ID: <20141008200458.GV14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-12-git-send-email-matt@console-pimps.org>
 <20141008181044.GI4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008181044.GI4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 08:10:44PM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> > +	limbo_bitmap = kmalloc(sizeof(long) * BITS_TO_LONGS(nr_bits) *
> > +			       nr_cpumask_bits, GFP_KERNEL);
> 
> That's going to be a _huge_ amount of memory on SGI class systems. Do we
> really need per-cpu storage for this?

Ah, no we don't.

Allocating it the above way just makes things easier because you can
index the array directly using your cpu.

I'll shrink this down to the minimum memory needed.

-- 
Matt Fleming, Intel Open Source Technology Center
