Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaBGRzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:55:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49008 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaBGRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:55:33 -0500
Message-ID: <52F51E10.8050208@linux.vnet.ibm.com>
Date: Fri, 07 Feb 2014 12:55:28 -0500
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org>
In-Reply-To: <20140207165113.GD3304@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020717-9332-0000-0000-00000307EF94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 11:51 AM, Tejun Heo wrote:
> Hello,
>
> (cc'ing Lai as he knows a lot of workqueue code and quoting the whole
> body for him)
>
> Hmmm.... my memory is a bit rusty and nothing rings a bell
> immediately.  Can you please try the patch at the end of this message
> and report the debug message?  Let's first find out what's going on.

I hit it quickly this time :) Here you go:

[  644.517558] ------------[ cut here ]------------
[  644.517567] WARNING: at kernel/workqueue.c:2156
[  644.517569] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun 
vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp 
scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
[  644.517603] CPU: 6 PID: 24 Comm: kworker/4:0 Not tainted 3.14.0-rc1 #2
[  644.517607] task: 00000000f7b49930 ti: 00000000f7b58000 task.ti: 
00000000f7b58000
[  644.517616] Krnl PSW : 0404c00180000000 000000000015b2a2 
(process_one_work+0x4ca/0x4ec)
[  644.517620]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 EA:3
Krnl GPRS: 000000000020f16f 00000000f7f0ce00 0000000000bc2a52 
0000000000000001
[  644.517625]            0000000000000000 0000000000000006 
0000000000000004 0000000000bc2a4e
[  644.517629]            0000000000000000 0000000084a37500 
0000000084a33000 0000000084a33018
[  644.517632]            00000000f7f21c00 0000000000b92500 
00000000f7b5bdd0 00000000f7b5bd70
[  644.517651] Krnl Code: 000000000015b294: ddf29640c05b	trt 
1600(243,%r9),91(%r12)
            000000000015b29a: a7f4fe56		brc	15,15af46
           #000000000015b29e: a7f40001		brc	15,15b2a0
           >000000000015b2a2: 92012000		mvi	0(%r2),1
            000000000015b2a6: a7f4ff10		brc	15,15b0c6
            000000000015b2aa: c03000533bd1	larl	%r3,bc2a4c
            000000000015b2b0: 95003000		cli	0(%r3),0
            000000000015b2b4: a774ff4e		brc	7,15b150
[  644.517679] Call Trace:
[  644.517683] ([<000000000015b094>] process_one_work+0x2bc/0x4ec)
[  644.517686]  [<000000000015b884>] worker_thread+0x178/0x39c
[  644.517690]  [<000000000016467e>] kthread+0x10e/0x128
[  644.517696]  [<0000000000728c96>] kernel_thread_starter+0x6/0xc
[  644.517699]  [<0000000000728c90>] kernel_thread_starter+0x0/0xc
[  644.517701] Last Breaking-Event-Address:
[  644.517705]  [<000000000015b29e>] process_one_work+0x4c6/0x4ec
[  644.517707] ---[ end trace 681ce8162e7857a0 ]---
[  644.517710] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6 pool->cpu=4
[  731.367023] XXX: worker->flags=0x1 pool->flags=0x0 cpu=1 pool->cpu=7




-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

