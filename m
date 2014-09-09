Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaIIQAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:00:53 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:64162 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbaIIQAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:00:51 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 9 Sep 2014 12:06:40 -0400 (EDT)
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <20140908185115.GI6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Peter Zijlstra wrote:

> On Mon, Sep 08, 2014 at 01:47:11PM -0400, Vince Weaver wrote:
> > Hello
> > 
> > so I finally had time to run my perf_fuzzer again and it has rapidly 
> > turned up an alarming crash that instant-reboots my core2 test machine.
> 
> Urgh, of course :/

So possibly was a waste of time, as it bisects to:

	commit 5e467e27b7c7a11ef47068138248003e873674a1
	Author: Tony Luck <tony.luck@intel.com>
	Date:   Wed Jul 30 14:05:15 2014 -0700

	    [IA64] Wire up getrandom() system call

Which makes no sense at all :(

The times the testcase fails give some pretty spectacular error messages:


[   78.018145] NOHZ: local_softirq_pending 100
[   83.012661] BUG: Bad page map in process perf_fuzzer  pte:ffff8800cafc5190 pmd:119d00067
[   83.020863] addr:000000000120c000 vm_flags:00100073 anon_vma:ffff8800cae19dc0 mapping:          (null) index:120c

[  316.040001] general protection fault: 0000 [#1] 

[  178.024220] perf_fuzzer[2788]: segfault at ffff88011fa7bef8 ip 00007f8c0e088c2f sp 00007fff003315e0 error 5

[ 2616.535995] Kernel panic - not syncing: Lost physical address for unconsumed uncorrectable error


[  751.656861] NOHZ: local_softirq_pending 100
[  756.009271] traps: perf_fuzzer[4236] trap invalid opcode ip:4044c0 sp:7fffb0ed6f90 error:0
[  756.017590] BUG: unable to handle kernel paging request

among others.

Vince
