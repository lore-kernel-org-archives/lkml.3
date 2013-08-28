Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3H1QtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:49:13 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:53486 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752677Ab3H1QtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:49:11 -0400
Date: Wed, 28 Aug 2013 12:50:36 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Dave Jones <davej@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
In-Reply-To: <20130828162321.GA14689@redhat.com>
Message-ID: <alpine.DEB.2.02.1308281245370.6937@pianoman.cluster.toy>
References: <20130828034627.GA30596@redhat.com> <20130828103101.3f5679bc@gandalf.local.home> <20130828162321.GA14689@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020203.521E2A06.0209,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, Dave Jones wrote:
> Quite often just rerunning that last syscall that caused the oops/warn
> isn't sufficient to trigger an issue. (Though it may be for this specific
> bug that may not be the case..)
> 
> Vince has a variant of trinity focussed just on perf which also has some
> neat replay/bisecting capabilities to narrow down test cases.
> I think I might need to add something like that at some point.

Yes, you can get the perf_fuzzer code here:
   git clone https://github.com/deater/perf_event_tests.git
in the fuzzer directory

Bisecting down which perf_event_open() call causes problems is still very 
labor intensive even with the other tools I've added to help.  Even if the 
bug is triggered right away (within the first 100,000 calls or so) it can 
take hours to narrow things down to the two or three syscalls needed to 
reproduce the problem.  Especially if you need to reboot after triggering 
the issue.

Vince
