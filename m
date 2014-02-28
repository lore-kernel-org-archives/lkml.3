Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaB1QXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:23:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:14374 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447AbaB1QXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:23:20 -0500
Date: Fri, 28 Feb 2014 11:23:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCHv2] x86 trace: Fix page fault tracing bug
Message-ID: <20140228112317.59b63a04@gandalf.local.home>
In-Reply-To: <5310B54F.3000709@zytor.com>
References: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
	<20140228154708.GI9987@twins.programming.kicks-ass.net>
	<20140228160526.GD1133@krava.brq.redhat.com>
	<5310B54F.3000709@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 08:11:59 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> If so, do we need to hoist the reading of %cr2 all the way into assembly
> or something else?

Function tracing code should not fault. Peter and Jiri were discussing
on IRC to make sure that perf could not enable userspace stack tracing
for function tracing.

At this point, I would say, lets get rid of any users of function
tracing callbacks that can fault. There callbacks are limited in
context even more so than any other context (faults, interrupts, and
NMIs).

-- Steve
