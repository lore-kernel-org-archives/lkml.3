Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3JZIsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 04:48:41 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57993 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3JZIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 04:48:39 -0400
Date: Sat, 26 Oct 2013 10:48:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
Message-ID: <20131026084836.GC14237@gmail.com>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu>
 <1382695687.12254.4.camel@pippen.local.home>
 <alpine.DEB.2.10.1310250906110.22710@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1310251726001.31246@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310251726001.31246@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> I don't know if there are any better ways to try to debug things 
> than the printk route.  Though that has its own problems as the 
> printk's themselves start showing up in the ftrace traces.

One additional brute-force method is earlyprintk=...,keep and 
marking the (handful of) earlyprintk functions (and snprintf) 
notrace, plus turning off printk itself completely.

That gives a completely instrumentation-free and locking-free 
console output function of last resort :-/

Thanks,

	Ingo
