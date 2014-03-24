Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaCXIHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:07:13 -0400
Received: from m13-72.163.com ([220.181.13.72]:44620 "EHLO m13-72.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaCXIGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:06:08 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 04:06:07 EDT
X-Originating-IP: [221.237.158.191]
Date: Mon, 24 Mar 2014 15:49:53 +0800 (CST)
From: "wei zhang" <asuka.com@163.com>
To: "Wei Zhang" <asuka.com@163.com>
Cc: xeb@mail.ru, davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:[PATCH] ipv4: gre: Fix null pointer dereference in
 gre_cisco_err()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <1395646471-637-1-git-send-email-asuka.com@163.com>
References: <1395646471-637-1-git-send-email-asuka.com@163.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3f46e558.12f9f.144f3113038.Coremail.asuka.com@163.com>
X-CM-TRANSID: SMGowAAXH1ei4y9Tya0cAA--.30758W
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/1tbiMhdY1lD-rh8XIgACsC
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2O87Ni9013596

The crash is occur on Centos 6.4, when we use gre vport of openvswitch!

<1>BUG: unable to handle kernel NULL pointer dereference at (null)
<1>IP: [<(null)>] (null)
<4>PGD c2910b067 PUD c2927d067 PMD 0Â 
<4>Oops: 0010 [#1] SMPÂ 
<4>last sysfs file: /sys/devices/virtual/net/gretap0/flags
<4>CPU 20Â 
<4>Modules linked in: ip_gre ip_tunnel xt_conntrack act_police cls_basic sch_ingress veth ipt_REDIRECT ipmi_devintf ipv6 openvswitch vxlan iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security ip_tables power_meter sg dcdbas microcode sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp tg3 ext4 jbd2 mbcache sd_mod crc_t10dif ahci wmi megaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: speedstep_lib]
<4>
<4>Pid: 2358, comm: ovs-vswitchd Not tainted 2.6.32-358.123.2.openstack.el6.x86_64 #1 Dell Inc. PowerEdge R620/0D2D5F
<4>RIP: 0010:[<0000000000000000>] Â [<(null)>] (null)
<4>RSP: 0018:ffff880053743c70 Â EFLAGS: 00010282
<4>RAX: ffffffffa01cbe20 RBX: ffff880bda46ecc0 RCX: 0000000000000000
<4>RDX: ffff880053743c78 RSI: 0000000000000000 RDI: ffff880bda46ecc0
<4>RBP: ffff880053743ca8 R08: 000000005617f772 R09: 0000000000000000
<4>R10: 0000000000000000 R11: 0000000000000000 R12: ffff880053743c78
<4>R13: 0000000000000000 R14: ffff880be5a5b244 R15: 0000000000000000
<4>FS: Â 00007fe5d5f837c0(0000) GS:ffff880053740000(0000) knlGS:0000000000000000
<4>CS: Â 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>CR2: 0000000000000000 CR3: 0000000c2a804000 CR4: 00000000000407e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process ovs-vswitchd (pid: 2358, threadinfo ffff880c284e0000, task ffff880c28d1f500)
<4>Stack:
<4> ffffffff814c6e61 00000000aba73000 0000000000000000 ffff880053743cc8
<4><d> 000000000000002f ffff880bda46ecc0 ffff881800deb200 ffff880053743cb8
<4><d> ffffffff814c676b ffff880053743cf8 ffffffff814afa91 ffff880053743ce8
<4>Call Trace:
<4> <IRQ>Â 
<4> [<ffffffff814c6e61>] ? gre_cisco_err+0x71/0x80
<4> [<ffffffff814c676b>] gre_err+0x4b/0x50
<4> [<ffffffff814afa91>] icmp_unreach+0x141/0x2e0
<4> [<ffffffff814b02e0>] icmp_rcv+0x290/0x330
<4> [<ffffffff814a8c71>] ? raw_local_deliver+0x221/0x250
<4> [<ffffffff8148222d>] ip_local_deliver_finish+0xdd/0x2d0
<4> [<ffffffff814824b8>] ip_local_deliver+0x98/0xa0
<4> [<ffffffff8148197d>] ip_rcv_finish+0x12d/0x440
<4> [<ffffffff81481f05>] ip_rcv+0x275/0x350
<4> [<ffffffffa01ca503>] ? ovs_netdev_frame_hook+0xb3/0x110 [openvswitch]
<4> [<ffffffff81449e6b>] __netif_receive_skb+0x4ab/0x750
<4> [<ffffffff8144a1aa>] process_backlog+0x9a/0x100
<4> [<ffffffff8144f483>] net_rx_action+0x103/0x2f0
<4> [<ffffffff810770b1>] __do_softirq+0xc1/0x1e0
<4> [<ffffffff8100c1cc>] ? call_softirq+0x1c/0x30
<4> [<ffffffff8100c1cc>] call_softirq+0x1c/0x30
<4> <EOI>Â 
<4> [<ffffffff8100de05>] ? do_softirq+0x65/0xa0
<4> [<ffffffff81076f3a>] local_bh_enable+0x9a/0xb0
<4> [<ffffffffa01c3b9c>] ovs_packet_cmd_execute+0x20c/0x240 [openvswitch]
<4> [<ffffffff81476013>] genl_rcv_msg+0x203/0x250
<4> [<ffffffff81475e10>] ? genl_rcv_msg+0x0/0x250
<4> [<ffffffff81474ca9>] netlink_rcv_skb+0xa9/0xd0
<4> [<ffffffff81475df5>] genl_rcv+0x25/0x40
<4> [<ffffffff814748db>] netlink_unicast+0x2db/0x320
<4> [<ffffffff81475350>] netlink_sendmsg+0x2c0/0x3d0
<4> [<ffffffff81436b33>] sock_sendmsg+0x123/0x150
<4> [<ffffffff814387e3>] ? sock_recvmsg+0x133/0x160
<4> [<ffffffff81096da0>] ? autoremove_wake_function+0x0/0x40
<4> [<ffffffff81197af0>] ? pollwake+0x0/0x60
<4> [<ffffffff81197af0>] ? pollwake+0x0/0x60
<4> [<ffffffff8118c687>] ? pipe_read+0x2a7/0x4e0
<4> [<ffffffff81197af0>] ? pollwake+0x0/0x60
<4> [<ffffffff81438326>] __sys_sendmsg+0x406/0x420
<4> [<ffffffff811c7c54>] ? ep_scan_ready_list+0x194/0x1a0
<4> [<ffffffff811c7dae>] ? ep_poll+0x12e/0x330
<4> [<ffffffff8121cb26>] ? security_file_permission+0x16/0x20
<4> [<ffffffff81438549>] sys_sendmsg+0x49/0x90
<4> [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
<4>Code: Â Bad RIP value.
<1>RIP Â [<(null)>] (null)
<4> RSP <ffff880053743c70>
<4>CR2: 0000000000000000ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
