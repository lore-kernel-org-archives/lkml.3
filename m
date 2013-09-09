Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3IIQGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:06:14 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:59032 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3IIQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:06:12 -0400
Date: Mon, 9 Sep 2013 18:06:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130909160608.GB25555@gmail.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
 <20130909111749.GP31370@twins.programming.kicks-ass.net>
 <20130909113640.GA16401@krava.redhat.com>
 <20130909115518.GA26785@twins.programming.kicks-ass.net>
 <20130909140339.GB16401@krava.redhat.com>
 <522DD6FF.50107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DD6FF.50107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/9/13 7:03 AM, Jiri Olsa wrote:
> >my usage currently is to having this running during the day:
> >(well whenever I remember to run it.. ;-) )
> >
> >   [jolsa@krava perf]$ sudo ./perf record -g -M 1m -a
> >
> >and checking report when the system or app get stuck
> >
> >with multiple files I can just easily (or automaticaly)
> >remove old ones without restarting session
> 
> Aren't you losing potentially important events by doing that -- FORK, 
> COMM, MMAP?

I suspect these could/should be tracked and emitted fully (in bulk) when a 
new data file is opened, so that each partial data file is fully 
consistent?

> I have a flight recorder style command that address this problem 
> (long-running/daemons) by processing task events and then stashing the 
> sample events on a time-ordered list with chopping to maintain the time 
> window.

Could this be used to emit currently relevant task context?

Btw., I also think it would be useful to have kernel support for that - 
the 'collections' stuff I talked about a good while ago: the kernel would 
work with user-space to iterate over all MMAPs and all running COMMs at 
the opening of a tracing session.

That way we could avoid racy access to /proc, we could make sure that all 
information that is emitted by FORK/COMM/MMAP is also emitted for the 
'bulk' data, etc.

Thanks,

	Ingo
