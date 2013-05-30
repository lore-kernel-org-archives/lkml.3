Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3E3Mqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:46:32 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54947 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3E3MqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:46:23 -0400
Date: Thu, 30 May 2013 08:51:00 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130530072532.GF4341@laptop>
Message-ID: <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
References: <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523125218.GB23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu> <20130530072532.GF4341@laptop>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Peter Zijlstra wrote:
> 
> Awesome! How specific is it to perf? I mean, would that tool work
> equally well for other tinity report?

No, it's fairly specific to my perf_fuzzer.  I only use trinity code to 
set up the perf_event_open() attr parameters, everything else I use my own 
code for.

The logging output from perf_fuzzer is fairly straightforward.  Just a 
single char indicating which syscall and a space separated list of 
the result (if relevant) and then all the syscall parameters.

The logging output can then be used by both the replayer and the 
sample-code generator.

While in theory this could be extended to something generic, currently it 
only works for perf_event_open/close/ioctl/read/write/mmap/munmap, and
even then it takes some shortcuts because I know it will only be run when 
finding perf_event problems.

The code for all of this is here if anyone else wants to play with it.
https://github.com/deater/perf_event_tests/tree/master/fuzzer

> I'll go prod, thanks again!

The bug looks related to hw breakpoints, not sure if the bugs Oleg 
Nesterov has been reporting in this area might be relevant or not.

Vince
