Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaJHOuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:50:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaJHOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:50:04 -0400
Date: Wed, 8 Oct 2014 16:49:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/11] perf/x86/intel: Support task events with Intel CQM
Message-ID: <20141008144957.GK10832@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-11-git-send-email-matt@console-pimps.org>
 <20141008110743.GF4750@worktop.programming.kicks-ass.net>
 <20141008121044.GS14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008121044.GS14343@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:10:44PM +0100, Matt Fleming wrote:
> Ah, interesting.
> 
> I dropped the internal scheduling because I preferred the idea of
> "failing fast", in the sense that if we can't schedule multiple events
> simultaneously because they conflict, we should report that to the user
> at event init time, rather than trying to manage the conflict ourselves,
> with the resultant loss of accuracy.

The thing is, with multiplexing you cannot fail at event creation time
anyhow. The only time where you can 'fail' is when programming the PMU,
when its full its full.

Those that don't fit, get to wait their turn.
