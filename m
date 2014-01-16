Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaAPRME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:12:04 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:38964 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaAPRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:11:59 -0500
Date: Thu, 16 Jan 2014 12:13:10 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Will Deacon <will.deacon@arm.com>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
In-Reply-To: <20140114105721.GU7572@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1401161209280.1996@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu> <20140108225315.GG31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu> <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu> <20140110094056.GK31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu> <20140114105721.GU7572@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Peter Zijlstra wrote:

> On Mon, Jan 13, 2014 at 11:55:17PM -0500, Vince Weaver wrote:

> > I don't see an existing pmu capabilities struct... or do you mean
> > coming up with one?
> 
> Yeah, adding one.

So would it be a struct, or just an integer with flags?

> > Would it only hold an "overflow_interrupt_available" flag, or are
> > there other generic capabilities it would be handy to know about?
> 
> Possible (other) flags could be:
> 
>   PMU_HAS_INT      -- would allow sampling events
>   PMU_HAS_PRECISE  -- would allow any ::precise value
>   PMU_HAS_FILTER   -- would allow all os/user/etc. flags

should we export these to userspace somehow?

It would be handy to be able to tell you're getting EOPNOTSUP because
PMU_HAS_INT is not set for your pmu, rather than trying to guess why 
things are failing.

Vince
