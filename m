Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3JHTgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:36:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49043 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3JHTgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:36:17 -0400
Date: Tue, 8 Oct 2013 21:36:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008193613.GA7315@gmail.com>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
 <20131008155131.GA31975@redhat.com>
 <5254313F.4030409@gmail.com>
 <20131008162451.GA1848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008162451.GA1848@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Tue, Oct 08, 2013 at 10:22:23AM -0600, David Ahern wrote:
>  > On 10/8/13 9:51 AM, Dave Jones wrote:
>  > > On Tue, Oct 08, 2013 at 08:59:38AM +0200, Ingo Molnar wrote:
>  > >
>  > >   > You might want to concentrate your efforts from fighting perf
>  > >   > functionality towards decreasing per tracepoint overhead instead,
>  > >   > without hurting kernel functionality and maintainability.
>  > >
>  > > Making it easier to disable perf entirely would be desirable for one use case.
>  > > I can't do a trinity run for more than a few hours for the last few months
>  > > without hitting perf/ftrace bugs that no-one seems to be able to get their
>  > > heads around.
>  > 
>  > Looks like trinity has an exclude syscall option. Seems like that option 
>  > can be used to avoid perf_event_open (haven't tried though).
> 
> You'd think that, but for whatever reason, ftrace/perf oopses still happen.

Peter is working on it - but it's slow. Could you try to disable 
sys_perf_open, ptrace and the NMI watchdog? No perf functionality should 
be used in that case. If you disable CONFIG_FTRACE then no ftrace 
functionality should be used.

Thanks,
	
	Ingo
