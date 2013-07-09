Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3GIXDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab3GIXDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:03:53 -0400
Date: Tue, 9 Jul 2013 19:03:16 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Subject: Re: timer: lockup in run_timer_softirq()
Message-ID: <20130709230316.GB13855@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
	tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
References: <51DC902F.3070403@oracle.com>
 <20130709224706.GA13855@redhat.com>
 <51DC9379.9050408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC9379.9050408@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:49:29PM -0400, Sasha Levin wrote:
 > On 07/09/2013 06:47 PM, Dave Jones wrote:
 
 > >   > [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run:
 > >   > 697182.008 msecs
 > >
 > > I've been reporting these (and other traces) for a while https://lkml.org/lkml/2013/7/5/185 [1]
 > > on bare-metal.
 > 
 > Interesting. It's the first time I'm seeing these, but I haven't really changed
 > anything in my configuration.
 > 
 > Are you also seeing the "NMI handler took too long" messages?

Now that I look closer, one difference is you're seeing arch_trigger_all_cpu_backtrace_handler
in that message. I'm seeing them from perf_event_nmi_handler.

	Dave


