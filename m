Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBMR6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:58:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39171 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaBMR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:58:49 -0500
Message-ID: <52FD07B2.5080402@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 12:58:10 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org> <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org> <52FB90C6.4010701@linux.vnet.ibm.com> <52FC3C83.8020303@cn.fujitsu.com>
In-Reply-To: <52FC3C83.8020303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021317-8236-0000-0000-0000071A4339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 10:31 PM, Lai Jiangshan wrote:
> On 02/12/2014 11:18 PM, Jason J. Herne wrote:

> Could you use the following patch for test if Tejun doesn't give you a new one.

Lai,

Here is the output using the patch you asked me to run with.

[ 5779.795687] ------------[ cut here ]------------
[ 5779.795695] WARNING: at kernel/workqueue.c:2159
[ 5779.795698] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi tape_3590 qeth_l2 tape tape_class vhost_net tun 
vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp 
scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
[ 5779.795733] CPU: 4 PID: 270 Comm: kworker/5:1 Not tainted 3.14.0-rc1 #1
[ 5779.795738] task: 0000000001938000 ti: 00000000f4d9c000 task.ti: 
00000000f4d9c000
[ 5779.795750] Krnl PSW : 0404c00180000000 000000000015b452 
(process_one_work+0x666/0x688)
[ 5779.795756]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 EA:3
Krnl GPRS: 000003210f9db000 0000000000bc2a52 0000000001b640c0 
0000000000000001
[ 5779.795757]            0000000000000000 0000000000000004 
0000000000000005 00000000ffffffff
[ 5779.795759]            0000000000000000 0000000084a43500 
0000000084a3f000 0000000084a3f018
[ 5779.795763]            0000000001b640c0 0000000000735d18 
00000000f4d9fdc8 00000000f4d9fd50
[ 5779.795781] Krnl Code: 000000000015b444: dd1a9640c05b	trt 
1600(27,%r9),91(%r12)
            000000000015b44a: a7f4fd9e		brc	15,15af86
           #000000000015b44e: a7f40001		brc	15,15b450
           >000000000015b452: 92011000		mvi	0(%r1),1
            000000000015b456: a7f4fe63		brc	15,15b11c
            000000000015b45a: c03000533af9	larl	%r3,bc2a4c
            000000000015b460: 95003000		cli	0(%r3),0
            000000000015b464: a774ff3e		brc	7,15b2e0
[ 5779.795810] Call Trace:
[ 5779.795814] ([<000000000015b0ea>] process_one_work+0x2fe/0x688)
[ 5779.795817]  [<000000000015ba62>] worker_thread+0x1a6/0x3d4
[ 5779.795822]  [<00000000001648c2>] kthread+0x10e/0x128
[ 5779.795828]  [<0000000000728ed6>] kernel_thread_starter+0x6/0xc
[ 5779.795832]  [<0000000000728ed0>] kernel_thread_starter+0x0/0xc
[ 5779.795834] Last Breaking-Event-Address:
[ 5779.795837]  [<000000000015b44e>] process_one_work+0x662/0x688
[ 5779.795840] ---[ end trace 8b6353b0f2821ec9 ]---
[ 5779.795844] XXX: worker->flags=0x1 pool->flags=0x0 cpu=4 
pool->cpu=5(1) rescue_wq=          (null)
[ 5779.795848] XXX: last_unbind=-44 last_rebind=0 last_rebound_clear=0 
nr_exected_after_rebound_clear=0
[ 5779.795852] XXX: sleep=-39 wakeup=0
[ 5779.795855] XXX: cpus_allowed=5
[ 5779.795857] XXX: cpus_allowed_after_rebinding=5
[ 5779.795861] XXX: after schedule(), cpu=4

You had asked about reproducing this. This is on the S390 platform, I'm 
not sure if that makes any difference.

The workload is:
2 processes onlining random cpus in a tight loop by using 'echo 1 > 
/sys/bus/cpu.../online'
2 processes offlining random cpus in a tight loop by using 'echo 0 > 
/sys/bus/cpu.../online'
Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27

The machine has 10 processors.
The warning message some times hits within a few minutes on starting the 
workload. Other times it takes several hours.

Please let me know if you have further questions.

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

