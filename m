Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBJPcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:32:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36202 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbaBJPcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:32:18 -0500
Message-ID: <52F8F0FB.3080206@linux.vnet.ibm.com>
Date: Mon, 10 Feb 2014 10:32:11 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org>
In-Reply-To: <20140207193604.GA8833@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021015-7182-0000-0000-000009CC00F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 02:36 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Feb 07, 2014 at 12:55:28PM -0500, Jason J. Herne wrote:
>> [  644.517710] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6 pool->cpu=4
>> [  731.367023] XXX: worker->flags=0x1 pool->flags=0x0 cpu=1 pool->cpu=7
>
> Sorry, still no idea how this can happen.  Can you please try the
> following?
>

Here are the results:

[  950.778326] ------------[ cut here ]------------
[  950.778334] WARNING: at kernel/workqueue.c:2156
[  950.778336] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi tape_3590 tape tape_class qeth_l2 vhost_net tun 
vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp 
scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
[  950.778370] CPU: 6 PID: 16 Comm: kworker/2:0 Not tainted 3.14.0-rc1 #1
[  950.778375] task: 00000000f7cc4b90 ti: 00000000f7ce8000 task.ti: 
00000000f7ce8000
[  950.778385] Krnl PSW : 0404c00180000000 000000000015b386 
(process_one_work+0x59a/0x5c0)
[  950.778389]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 EA:3
Krnl GPRS: 00000000001ee417 00000000f7f0ce00 0000000000bc2a52 
0000000000000001
[  950.778396]            0000000000000000 0000000000000006 
0000000000000002 0000000000bc2a4e
[  950.778400]            0000000000000000 0000000084a1f500 
0000000084a1b000 0000000084a1b018
[  950.778404]            00000000f7f52900 0000000000b92500 
00000000f7cebdd0 00000000f7cebd68
[  950.778423] Krnl Code: 000000000015b37a: 92013000		mvi	0(%r3),1
            000000000015b37e: a7f4ff31		brc	15,15b1e0
           #000000000015b382: a7f40001		brc	15,15b384
           >000000000015b386: 92012000		mvi	0(%r2),1
            000000000015b38a: a7f4feae		brc	15,15b0e6
            000000000015b38e: 41102018		la	%r1,24(%r2)
            000000000015b392: e31020180020	cg	%r1,24(%r2)
            000000000015b398: a784ff59		brc	8,15b24a
[  950.778451] Call Trace:
[  950.778455] ([<000000000015b0b4>] process_one_work+0x2c8/0x5c0)
[  950.778459]  [<000000000015b98e>] worker_thread+0x19a/0x3c0
[  950.778463]  [<00000000001647c2>] kthread+0x10e/0x128
[  950.778469]  [<0000000000728dd6>] kernel_thread_starter+0x6/0xc
[  950.778472]  [<0000000000728dd0>] kernel_thread_starter+0x0/0xc
[  950.778475] Last Breaking-Event-Address:
[  950.778478]  [<000000000015b382>] process_one_work+0x596/0x5c0
[  950.778481] ---[ end trace 643b2850ca4b7ed8 ]---
[  950.778485] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6 pool->cpu=2 
rescue_wq=          (null)
[  950.778488] XXX: last_unbind=-7 last_rebind=0 last_rebound_clear=0 
nr_exected_after_rebound_clear=0
[  950.778492] XXX: cpus_allowed=2
[  950.778495] XXX: cpus_allowed_after_rebinding=2


-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

