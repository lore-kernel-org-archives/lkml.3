Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab3JOMgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:36:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3JOMgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:36:07 -0400
Date: Tue, 15 Oct 2013 14:35:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
Message-ID: <20131015123527.GI10651@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
 <20131014140618.GA26604@gmail.com>
 <525D1234.5060001@gmail.com>
 <20131015102621.GE10651@twins.programming.kicks-ass.net>
 <20131015122522.GB2402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015122522.GB2402@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:25:22PM +0200, Ingo Molnar wrote:
> Really, please make it _symmetric_ ...
> 
> Single core systems are becoming a historic curiosity, should we should 
> justify every piece of extra complexity we add for them.
> 
> So I'd rather see obvious SMP code where the UP case works fine too, and 
> _then_ maybe check a separate patch that adds the UP optimization, with 
> (object size) numbers proving that it's worth it, etc.

That's a slightly larger task than it appears; the core scheduler code
they rely on with smp doesn't exist on up.

We can do this but we need to do it scheduler wide.
