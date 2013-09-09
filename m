Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3IIOck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:32:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab3IIOcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:32:39 -0400
Date: Mon, 9 Sep 2013 16:31:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130909143134.GA27974@krava.redhat.com>
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

On Mon, Sep 09, 2013 at 07:11:11AM -0700, David Ahern wrote:
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
> Aren't you losing potentially important events by doing that --
> FORK, COMM, MMAP?

those are synthesized for each file via synthesize_record
function, see:

[PATCH 19/25] perf tools: Move synthesizing into single function

> 
> I have a flight recorder style command that address this problem
> (long-running/daemons) by processing task events and then stashing
> the sample events on a time-ordered list with chopping to maintain
> the time window.

so far I noticed there could be race among EXIT and remaining
SAMPLE events on another CPU mmap than EXIT event.. ending up
with EXIT being stored in the old file, while SAMPLEs will get
to the new one

I was thinking about some 'perf daemon' so I dont need to run that
manually.. seems similar to what you did

jirka
