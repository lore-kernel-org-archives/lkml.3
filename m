Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaJHUAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:00:03 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35839 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaJHT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:59:59 -0400
Date: Wed, 8 Oct 2014 20:59:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Message-ID: <20141008195956.GU14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-12-git-send-email-matt@console-pimps.org>
 <20141008180814.GH4750@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410082029020.4292@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410082029020.4292@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 09:02:16PM, Thomas Gleixner wrote:
> On Wed, 8 Oct 2014, Peter Zijlstra wrote:
> > On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> > > +	preempt_disable();
> 
> < SNIP loooong code >
> 
> > > +	preempt_enable();
> > 
> > Why is all that under preempt_disable()?
> 
> To make life harder for people who care about latencies and
> deterministic behaviour perhaps?

Yeah that looks... wrong.

I'll fix that.

-- 
Matt Fleming, Intel Open Source Technology Center
