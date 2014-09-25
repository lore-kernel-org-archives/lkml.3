Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaIYQBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:01:34 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:19475 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbaIYQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:01:31 -0400
From: Manish Chopra <manish.chopra@qlogic.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        netdev <netdev@vger.kernel.org>
Subject: RE: netxen: BUG: sleeping function called from invalid context at
 include/linux/netdevice.h:476
Thread-Topic: netxen: BUG: sleeping function called from invalid context at
 include/linux/netdevice.h:476
Thread-Index: AQHP2MwKiby+nrmk60+eQjYIAzdSKpwR/2EQ
Date: Thu, 25 Sep 2014 16:01:29 +0000
Message-ID: <31AFFC7280259C4184970ABA9AFE8B93E083A9B7@avmb3.qlogic.org>
References: <1411654896.15810.52.camel@marge.simpson.net>
In-Reply-To: <1411654896.15810.52.camel@marge.simpson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7571 signatures=670528
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1409250167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8PG1eo7024030

> -----Original Message-----
> From: Mike Galbraith [mailto:umgwanakikbuti@gmail.com]
> Sent: Thursday, September 25, 2014 7:52 PM
> To: linux-kernel
> Cc: Manish Chopra; Sony Chacko; Rajesh Borundia; netdev
> Subject: netxen: BUG: sleeping function called from invalid context at
> include/linux/netdevice.h:476
> 
> Greetings,
> 
> While testing some sched patches that require CONFIG_DEBUG_ATOMIC_SLEEP,
> the below fell out.
> 
> /etc/init.d/network restart -> gripe
> 
> [   97.850408] BUG: sleeping function called from invalid context at
> include/linux/netdevice.h:476
> [   97.941177] in_atomic(): 1, irqs_disabled(): 0, pid: 6458, name: ip
> [   98.012784] Preemption disabled at:[<ffffffffa0509719>]
> __netxen_nic_down+0x79/0x1b0 [netxen_nic]
> [   98.047283]
> [   98.047289] CPU: 63 PID: 6458 Comm: ip Tainted: G            E  3.17.0-default #7
> [   98.047291] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66
> 07/07/2010
> [   98.047295]  00000000ffffffff ffff88003702f528 ffffffff81589dbd
> 0000000000000000
> [   98.047301]  ffff88026ee96210 ffff88003702f548 ffffffff8108e1df
> ffff88026ee96210
> [   98.047305]  0000000000000000 ffff88003702f578 ffffffff8108e298
> ffff88026bf89c38
> [   98.047307] Call Trace:
> [   98.047313]  [<ffffffff81589dbd>] dump_stack+0x4d/0x90
> [   98.047331]  [<ffffffff8108e1df>] ___might_sleep+0x10f/0x180
> [   98.047343]  [<ffffffff8108e298>] __might_sleep+0x48/0xd0
> [   98.047348]  [<ffffffffa0506d54>] netxen_napi_disable+0x84/0xe0
> [netxen_nic]
> [   98.047353]  [<ffffffffa05097f0>] __netxen_nic_down+0x150/0x1b0
> [netxen_nic]
> [   98.047367]  [<ffffffffa0509b0b>] netxen_nic_close+0x1b/0x20 [netxen_nic]
> [   98.047375]  [<ffffffff814aa525>] __dev_close_many+0x95/0xe0
> [   98.047379]  [<ffffffff814aa5a6>] __dev_close+0x36/0x50
> [   98.047384]  [<ffffffff814ab89c>] __dev_change_flags+0xac/0x180
> [   98.047389]  [<ffffffff814ab9a7>] dev_change_flags+0x37/0x80
> [   98.047398]  [<ffffffff814be874>] do_setlink+0x244/0x7e0
> [   98.047403]  [<ffffffff814c0310>] rtnl_newlink+0x5a0/0x7d0
> [   98.047408]  [<ffffffff814bfeba>] ? rtnl_newlink+0x14a/0x7d0
> [   98.047421]  [<ffffffff8105259c>] ? __do_page_fault+0x2ac/0x520
> [   98.047431]  [<ffffffff812a14a0>] ? apparmor_capable+0x20/0x60
> [   98.047436]  [<ffffffff814bf981>] rtnetlink_rcv_msg+0xa1/0x240
> [   98.047446]  [<ffffffff81308f86>] ? rhashtable_lookup_compare+0x46/0x70
> [   98.047451]  [<ffffffff814bf8e0>] ? __rtnl_unlock+0x20/0x20
> [   98.047463]  [<ffffffff814dc3d9>] netlink_rcv_skb+0x89/0xb0
> [   98.047466]  [<ffffffff814bfb7c>] rtnetlink_rcv+0x2c/0x40
> [   98.047468]  [<ffffffff814dbdc9>] netlink_unicast+0x119/0x180
> [   98.047473]  [<ffffffff81306a3c>] ? memcpy_fromiovec+0x6c/0x90
> [   98.047477]  [<ffffffff814dc7c0>] netlink_sendmsg+0x3c0/0x450
> [   98.047487]  [<ffffffff8149449c>] sock_sendmsg+0x9c/0xd0
> [   98.047497]  [<ffffffff810aa113>] ? __wake_up+0x53/0x70
> [   98.047502]  [<ffffffff8108e298>] ? __might_sleep+0x48/0xd0
> [   98.047509]  [<ffffffff814a204e>] ? verify_iovec+0x5e/0xf0
> [   98.047512]  [<ffffffff81494df6>] ___sys_sendmsg+0x436/0x440
> [   98.047515]  [<ffffffff8108e298>] ? __might_sleep+0x48/0xd0
> [   98.047523]  [<ffffffff81194513>] ? might_fault+0x43/0x50
> [   98.047525]  [<ffffffff81491eef>] ? copy_to_user+0x2f/0x40
> [   98.047528]  [<ffffffff814951cc>] ? ___sys_recvmsg+0x19c/0x310
> [   98.047531]  [<ffffffff8105259c>] ? __do_page_fault+0x2ac/0x520
> [   98.047538]  [<ffffffff8119e681>] ? __vma_link_rb+0x101/0x120
> [   98.047544]  [<ffffffff8119fef8>] ? do_brk+0x1c8/0x340
> [   98.047550]  [<ffffffff814924a2>] ? SyS_getsockname+0xb2/0xc0
> [   98.047555]  [<ffffffff81494fd9>] __sys_sendmsg+0x49/0x80
> [   98.047558]  [<ffffffff81495029>] SyS_sendmsg+0x19/0x20
> [   98.047567]  [<ffffffff8158f7a9>] system_call_fastpath+0x16/0x1b
> 
> (gdb) list *__netxen_nic_down+0x79
> 0x8749 is in __netxen_nic_down
> (drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c:1190).
> 1185            if (!test_and_clear_bit(__NX_DEV_UP, &adapter->state))
> 1186                    return;
> 1187
> 1188            smp_mb();
> 1189            spin_lock(&adapter->tx_clean_lock);
> 1190            netif_carrier_off(netdev);
> 1191            netif_tx_disable(netdev);
> 1192
> 1193            if (adapter->capabilities &
> NX_FW_CAPABILITY_LINK_NOTIFICATION)
> 1194                    netxen_linkevent_request(adapter, 0);

Hello Mike,

Thanks for finding this out. Mostly I have fix for it.
I will send a patch to net for fixing it after doing some testing.

Thanks,
Manish 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
