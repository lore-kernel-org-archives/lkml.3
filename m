Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3IPGHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:07:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41976 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3IPGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:07:45 -0400
Date: Mon, 16 Sep 2013 08:07:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
Message-ID: <20130916060736.GN21832@twins.programming.kicks-ass.net>
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
 <87mwng53ki.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwng53ki.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:18:21PM -0700, Andi Kleen wrote:
> tip-bot for Peter Zijlstra <tipbot@zytor.com> writes:
> > +
> > +	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
> > +	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
> >  
> >  	ds->pebs_index = ds->pebs_buffer_base;
> >  
> > +	n = (top - at) / x86_pmu.pebs_record_size;
> 
> 
> This adds a full slow division to the PEBS hot path.
> 
> Does not seem like a improvement to me.

There already was an implicit division there, and
sizeof(pebs_record_hsw) = 176, can it really optimize that constant
division?

I suppose we could go and introduce CONFIG_PERF_DEBUG and stuff sanity
checks under that.. :/
