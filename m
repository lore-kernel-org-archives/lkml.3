Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaJHOrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:47:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaJHOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:47:15 -0400
Date: Wed, 8 Oct 2014 16:47:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20141008144704.GJ10832@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
 <20141007194310.GC4750@worktop.programming.kicks-ass.net>
 <20141008103658.GP14343@console-pimps.org>
 <20141008121535.GT14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008121535.GT14343@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:15:35PM +0100, Matt Fleming wrote:
> I was having an interesting discussion with one of the teams using this
> stuff at Intel and they made the suggestion that when using,
> 
>   perf stat -p <pid>
> 
> we should by default opt for sharing an RMID between all tasks in that
> thread group, rather that assigning a new RMID for each task, which is
> what we do currently.
> 
> Right now, it's like the Oprah Winfrey of RMID assignment, "You get an
> RMID, and you get an RMID!"
> 
> Which means we'll run out of RMIDs quicker, and enable the rotation code
> sooner.
> 
> I'm wondering whether we should require that the user specify whether
> they want per-thread monitoring if using -p, via some perf tools event
> modifier, and make the record-per-thread-data scenario the exceptional
> case, rather than the default?

Right so perf cannot do this. And I'm not sure that's fixable, it
depends a bit on how the cqm thing deals with inherited events, IFF it
can reuse RMIDs for inherited events we might be able to extend the
syscall to install 'inherited' events throughout the process group,
instead of just the one thread.
