Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaBLPSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:18:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59509 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaBLPSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:18:36 -0500
Message-ID: <52FB90C6.4010701@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 10:18:30 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org> <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org>
In-Reply-To: <20140210231742.GK25350@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021215-0320-0000-0000-00000271F0E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 06:17 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, Feb 10, 2014 at 10:32:11AM -0500, Jason J. Herne wrote:
>> [  950.778485] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6
>> pool->cpu=2 rescue_wq=          (null)
>> [  950.778488] XXX: last_unbind=-7 last_rebind=0
>> last_rebound_clear=0 nr_exected_after_rebound_clear=0
>> [  950.778492] XXX: cpus_allowed=2
>> [  950.778495] XXX: cpus_allowed_after_rebinding=2
>
> So, everything looks kosher from workqueue side.  Weird.  cpus_allowed
> is properly set and everything.  The worker just isn't running on the
> cpu it's supposed to be on.  Can you please try the following?


Thanks for the fast responses. Here is the output from the last patch:


[34437.173991] WARNING: at kernel/workqueue.c:2156
[34437.173993] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun 
vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp 
scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
[34437.174030] CPU: 2 PID: 12 Comm: kworker/1:0 Not tainted 3.14.0-rc1 #1
[34437.174034] task: 00000000f7c9e4c0 ti: 00000000f7cbc000 task.ti: 
00000000f7cbc000
[34437.174046] Krnl PSW : 0404c00180000000 000000000015b406 
(process_one_work+0x61a/0x640)
[34437.174051]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 EA:3
Krnl GPRS: 000000007c325b00 0000000000bc2a52 00000000f7f52780 
0000000000000001
[34437.174057]            0000000000000000 0000000000000002 
0000000000000001 0000000000bc2a4e
[34437.174061]            0000000000000000 0000000084a13500 
0000000084a0f000 0000000084a0f018
[34437.174065]            00000000f7f52780 0000000000735d18 
00000000f7cbfdd0 00000000f7cbfd58
[34437.174085] Krnl Code: 000000000015b3fa: 92013000		mvi	0(%r3),1
            000000000015b3fe: a7f4ff31		brc	15,15b260
           #000000000015b402: a7f40001		brc	15,15b404
           >000000000015b406: 92011000		mvi	0(%r1),1
            000000000015b40a: a7f4fe84		brc	15,15b112
            000000000015b40e: 41102018		la	%r1,24(%r2)
            000000000015b412: e31020180020	cg	%r1,24(%r2)
            000000000015b418: a784ff59		brc	8,15b2ca
[34437.174115] Call Trace:
[34437.174118] ([<000000000015b0e0>] process_one_work+0x2f4/0x640)
[34437.174122]  [<000000000015ba0e>] worker_thread+0x19a/0x3c0
[34437.174126]  [<0000000000164842>] kthread+0x10e/0x128
[34437.174132]  [<0000000000728e56>] kernel_thread_starter+0x6/0xc
[34437.174136]  [<0000000000728e50>] kernel_thread_starter+0x0/0xc
[34437.174138] Last Breaking-Event-Address:
[34437.174141]  [<000000000015b402>] process_one_work+0x616/0x640
[34437.174144] ---[ end trace 52d8ee96597a2415 ]---
[34437.174148] XXX: worker->flags=0x1 pool->flags=0x0 cpu=2 
pool->cpu=1(1) rescue_wq=          (null)
[34437.174152] XXX: last_unbind=-34 last_rebind=0 last_rebound_clear=0 
nr_exected_after_rebound_clear=0
[34437.174156] XXX: cpus_allowed=1
[34437.174158] XXX: cpus_allowed_after_rebinding=1
[34437.174161] BUG: scheduling while atomic: kworker/1:0/12/0x00000002
[34437.174164] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun 
vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp 
scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
[34437.174194] CPU: 2 PID: 12 Comm: kworker/1:0 Tainted: G        W 
3.14.0-rc1 #1
[34437.174197]        00000000f7cbfb80 00000000f7cbfb90 0000000000000002 
0000000000000000
        00000000f7cbfc20 00000000f7cbfb98 00000000f7cbfb98 0000000000115f6a
        0000000000000003 0000000000c4da00 000000000000000a 000000000000000a
        00000000f7cbfbe0 00000000f7cbfb80 0000000000000000 0000000000000000
        0000000000000000 0000000000115f6a 00000000f7cbfb80 00000000f7cbfbd0
[34437.174273] Call Trace:
[34437.174279] ([<0000000000115e5c>] show_trace+0x100/0x148)
[34437.174282]  [<0000000000115f18>] show_stack+0x74/0xf4
[34437.174288]  [<0000000000720a9c>] dump_stack+0x88/0xb8
[34437.174291]  [<000000000071aa40>] __schedule_bug+0x78/0x90
[34437.174295]  [<00000000007237e4>] __schedule+0xb8c/0xbac
[34437.174299]  [<000000000015b21e>] process_one_work+0x432/0x640
[34437.174302]  [<000000000015ba0e>] worker_thread+0x19a/0x3c0
[34437.174306]  [<0000000000164842>] kthread+0x10e/0x128
[34437.174309]  [<0000000000728e56>] kernel_thread_starter+0x6/0xc
[34437.174313]  [<0000000000728e50>] kernel_thread_starter+0x0/0xc
[34437.174317] XXX: after schedule(), cpu=2




-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

