Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaIIROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:14:53 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34387 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaIIROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:14:51 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 9 Sep 2014 13:20:42 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Vince Weaver wrote:
> 
> [  751.656861] NOHZ: local_softirq_pending 100
> [  756.009271] traps: perf_fuzzer[4236] trap invalid opcode ip:4044c0 sp:7fffb0ed6f90 error:0
> [  756.017590] BUG: unable to handle kernel paging request

so it turns out that while it seems reproducible, it must be some sort of 
race condition and only happens like 75% of the time on a 3.17-rc4 kernel.

Almost managed to get an oops that last time:

[  222.457213] NOHZ: local_softirq_pending 100
[  222.712448] NOHZ: local_softirq_pending 100
[  222.947573] NOHZ: local_softirq_pending 100
[  229.168047] BUG: unable to handle kernel NULL pointer dereference at 0000000000000087
[  229.172003] IP: [<ffffffff81062cde>] scheduler_tick+0x56/0xbb
[  229.172003] PGD c4b72067 PUD c52df067 PMD 0 
[  229.172003] Thread overran stack, or stack corrupted
[  229.172003] Oops: 0000 [#1] SMP 
[  229.172003] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet coretemp evdev psmouse pcspkr ohci_pci ohci_hcd  
^P<C0><FF><FF><E8><FF><FF><A8>A!^A<88><FF><FF>hA!^A<88><FF>
<FF>^P}<CB>7(OCE) 

any advice on tracking this down?  I can fire up ftrace but it's unclear 
to me I will get anything useful as the system insta-reboots pretty 
quickly.

Vince
