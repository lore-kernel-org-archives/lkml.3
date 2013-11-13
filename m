Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3KMWbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:31:23 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:40051 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3KMWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:31:14 -0500
Date: Wed, 13 Nov 2013 17:39:33 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint yet another lockup
In-Reply-To: <20131112092458.GL5056@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1311131737100.5706@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311111158420.25509@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311111720190.26895@vincent-weaver-1.um.maine.edu> <20131112092458.GL5056@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Peter Zijlstra wrote:

> On Mon, Nov 11, 2013 at 05:28:21PM -0500, Vince Weaver wrote:
> > So are all tracepoints unsafe?  Or just a subset?
> 
> No, most should be fine. But finding the special ones seems interesting
> :/
> 
> Disabling them all for now sure seems like the safe option.

Update on this, it was a false positive.  It seems like the other crashes 
I was seeing were also caused by tracepoint 24, the fuzzer just found them 
via another code path I wasn't checking.

So from what I can tell the only troublesome tracepoint I've come across 
is the original irq_vectors/irq_work_exit problem.

Vince

