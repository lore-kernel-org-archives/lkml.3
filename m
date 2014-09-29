Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaI2FPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 01:15:25 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36291 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaI2FPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 01:15:22 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 29 Sep 2014 01:21:42 -0400 (EDT)
To: Cong Wang <cwang@twopensource.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1409290117350.20725@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com> <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
 <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Cong Wang wrote:

> On Wed, Sep 24, 2014 at 9:59 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:

> > Now that just might mean the patch pushed the code around enough so my
> > test doesn't trigger, but there is hope that maybe this fixes things.
> 
> I read this as it fixes your crash as well?

It makes a testcase I have stop triggering an instant reboot, but there 
have been various attempts to fix similar problems over the past few 
months and so far the general family of lockups/reboots still remains.

I'll have to start fuzzing with 3.17-rc7 and see if things are better now,
but it can take days to trigger this class of bugs.

> Sure, as I said in the changelog, it is a soft lockup which was triggered on
> dozens of machines here, it is actually pretty straightforward:

so you managed to trigger it with the perf utility?
Do you have the exact command line that triggered it?

Thanks,

Vince



> [5108912.562963] BUG: soft lockup - CPU#7 stuck for 22s! [perf:13856]
> [5108912.563173] Modules linked in: netconsole configfs ipv6 bonding
> dm_multipath video sbs sbshc hed acpi_pad acpi_memhotplug acpi_ipmi
> parport_pc lp parport tcp_diag inet_diag ipmi_si ipmi_devintf
> ipmi_msghandler dell_rbu igb dcdbas shpchp i2c_i801 i2c_core iTCO_wdt
> i7core_edac edac_core iTCO_vendor_support ioatdma dca microcode
> [5108912.563198] CPU 7
> [5108912.563199] Modules linked in: netconsole configfs ipv6 bonding
> dm_multipath video sbs sbshc hed acpi_pad acpi_memhotplug acpi_ipmi
> parport_pc lp parport tcp_diag inet_diag ipmi_si ipmi_devintf
> ipmi_msghandler dell_rbu igb dcdbas shpchp i2c_i801 i2c_core iTCO_wdt
> i7core_edac edac_core iTCO_vendor_support ioatdma dca microcode
> [5108912.563216]
> [5108912.563219] Pid: 13856, comm: perf Not tainted 3.4.78 #1 Dell
> Inc.  C6100           /0D61XP
> [5108912.563222] RIP: 0010:[<ffffffff810d9a6a>]  [<ffffffff810d9a6a>]
> perf_remove_from_context+0x8d/0xb4
> [5108912.563233] RSP: 0018:ffff8809ea39bd48  EFLAGS: 00000202
> [5108912.563235] RAX: 000000000000006d RBX: ffffffff810d6dcc RCX:
> 0000000000000000
> [5108912.563237] RDX: ffff88123fc8006d RSI: ffffffff810d6dcc RDI:
> ffff8808f8541c0c
> [5108912.563239] RBP: ffff8809ea39bd88 R08: 0000000000000001 R09:
> 0000000000000000
> [5108912.563241] R10: ffff8809abf95610 R11: ffff880a3a6c331c R12:
> 0000000000000000
> [5108912.563243] R13: 00000000000000ef R14: 0000000000000001 R15:
> 0000000000000000
> [5108912.563245] FS:  0000000000000000(0000) GS:ffff88123fc20000(0000)
> knlGS:0000000000000000
> [5108912.563248] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [5108912.563250] CR2: 00007f692e787180 CR3: 0000000001a0b000 CR4:
> 00000000000007e0
> [5108912.563252] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [5108912.563254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [5108912.563256] Process perf (pid: 13856, threadinfo
> ffff8809ea39a000, task ffff880a2167c470)
> [5108912.563258] Stack:
> [5108912.563260]  ffff880a3a6c32c0 ffff88048c7c3820 ffff8809ea39bd88
> ffff88048c7c3800
> [5108912.563265]  ffff88048c7c3800 ffff8808f8541c00 ffff8808f8541c10
> ffff88091b56c000
> [5108912.563269]  ffff8809ea39bdb8 ffffffff810d9bbe ffff8809ea39bdb8
> ffff880a2167c470
> [5108912.563273] Call Trace:
> [5108912.563278]  [<ffffffff810d9bbe>] perf_event_release_kernel+0x77/0x91
> [5108912.563282]  [<ffffffff810d9c56>] put_event+0x7e/0x86
> [5108912.563285]  [<ffffffff810d9dc0>] perf_release+0x10/0x14
> [5108912.563291]  [<ffffffff8112dfc0>] __fput+0xfe/0x1f6
> [5108912.563294]  [<ffffffff8112e0d2>] fput+0x1a/0x1c
> [5108912.563297]  [<ffffffff8112ad8d>] filp_close+0x72/0x7d
> [5108912.563303]  [<ffffffff8103efbf>] put_files_struct+0x6c/0xc3
> [5108912.563306]  [<ffffffff8103f057>] exit_files+0x41/0x46
> [5108912.563309]  [<ffffffff81040971>] do_exit+0x292/0x3b6
> [5108912.563312]  [<ffffffff81040b12>] do_group_exit+0x7d/0xa5
> [5108912.563315]  [<ffffffff81040b51>] sys_exit_group+0x17/0x1b
> [5108912.563320]  [<ffffffff814c2469>] system_call_fastpath+0x16/0x1b
