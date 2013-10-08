Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3JHUUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:20:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52102 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752488Ab3JHUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:20:04 -0400
Date: Tue, 8 Oct 2013 16:19:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008201959.GC15214@home.goodmis.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
 <20131008155131.GA31975@redhat.com>
 <5254313F.4030409@gmail.com>
 <20131008162451.GA1848@redhat.com>
 <20131008193613.GA7315@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008193613.GA7315@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:36:13PM +0200, Ingo Molnar wrote:
> 
> Peter is working on it - but it's slow. Could you try to disable 
> sys_perf_open, ptrace and the NMI watchdog? No perf functionality should 
> be used in that case. If you disable CONFIG_FTRACE then no ftrace 
> functionality should be used.
> 

Dave,

The ftrace oops you've been seeing is from the function tracer, you don't
need to disable all of ftrace, just CONFIG_FUNCTION_TRACER (and anything
that selects it: CONFIG_STACK_TRACER).

-- Steve

