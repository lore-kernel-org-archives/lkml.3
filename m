Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbbASDuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:50:17 -0500
Received: from smtpauth15.mfg.siteprotect.com ([64.26.60.147]:59486 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751090AbbASDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:50:16 -0500
Date: Sun, 18 Jan 2015 22:49:46 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference before
 moving the group
In-Reply-To: <alpine.DEB.2.10.1501161352070.8204@pianoman.cluster.toy>
Message-ID: <alpine.DEB.2.10.1501182245470.16482@pianoman.cluster.toy>
References: <20150116075746.GB2658@krava.brq.redhat.com> <20150116104644.GW23965@worktop.programming.kicks-ass.net> <20150116141104.GD21958@worktop.programming.kicks-ass.net> <alpine.DEB.2.10.1501161352070.8204@pianoman.cluster.toy>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.54BC7EF7.00A2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Vince Weaver wrote:
> 
> I just wanted to report that I've tested both this patch and Jiri's 
> original one and they both keep my easy-to-trigger-testcase from crashing 
> my core2 machine (when applied against 3.18).

I've continued fuzzing all weekend, with PeterZ's patch 
applied to 3.19-rc4.  It has managed to stay up without crashing, 
impressive.   

Fuzzing still turns up a few issues but no crashes:

[ 1753.904001] WARNING: CPU: 0 PID: 23800 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0x6a/0xf6()
[ 1753.904001] Can't find any breakpoint slot

(I thought we had fixed that one).

[80608.209702] Uhhuh. NMI received for unknown reason 3d on CPU 0.
[80608.212041] Do you have a strange power saving mode enabled?
[80608.212041] Dazed and confused, but trying to continue

(these are common but don't seem to affect system stability).

Vince
