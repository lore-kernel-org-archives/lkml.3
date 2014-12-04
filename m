Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbaLDQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:36:00 -0500
Received: from mail.smart-weblications.de ([188.65.144.61]:51343 "EHLO
	mail.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470AbaLDQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:35:57 -0500
Message-ID: <54808D8B.3080804@smart-weblications.de>
Date: Thu, 04 Dec 2014 17:36:27 +0100
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com>
In-Reply-To: <20141204075627.GE6390@secunet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 04.12.2014 08:56, schrieb Steffen Klassert:
> On Wed, Dec 03, 2014 at 03:55:30PM +0100, Smart Weblications GmbH - Florian Wiessner wrote:
>> Hi list,
>>
>>
>>
>> [16623.095403] BUG: unable to handle kernel paging request at 00000000010600d0
>> [16623.095445] IP: [<ffffffff81547767>] xfrm_selector_match+0x25/0x2f6
>> [16623.095480] PGD aeaea067 PUD 85d95067 PMD 0
>> [16623.095513] Oops: 0000 [#1] SMP
>> [16623.095543] Modules linked in: netconsole xt_nat xt_multiport veth ip_vs_rr
>> nfsd lockd nfs_acl auth_rpcgss sunrpc oid_registry iptable_mangle xt_mark
>> nf_conntrack_netlink nfnetlink ipt_MASQUERADE iptable_nat nf_nat_ipv4
>> nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_tcpudp iptable_filter ip_tables
>> cpufreq_ondemand cpufreq_powersave cpufreq_conservative cpufreq_userspace
>> ocfs2_stack_o2cb ocfs2_dlm bridge stp llc bonding fuse nf_conntrack_ftp 8021q
>> openvswitch gre vxlan xt_conntrack x_tables ocfs2_dlmfs dlm sctp ocfs2
>> ocfs2_nodemanager ocfs2_stackglue configfs rbd kvm_intel kvm coretemp ip_vs_ftp
>> ip_vs nf_nat nf_conntrack ctr twofish_generic twofish_x86_64 twofish_common
>> camellia_generic serpent_generic blowfish_generic blowfish_common cast5_generic
>> cast_common xcbc sha512_generic crypto_null af_key xfrm_algo psmouse serio_raw
>> i2c_i801 lpc_ich mfd_core evdev btrfs lzo_decompress lzo_compress
>> [16623.096062] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.33 #1
>> [16623.096091] Hardware name: Supermicro X9SCI/X9SCA/X9SCI/X9SCA, BIOS 1.1a
>> 09/28/2011
>> [16623.096137] task: ffffffff81804450 ti: ffffffff817f4000 task.ti: ffffffff817f4000
>> [16623.096182] RIP: 0010:[<ffffffff81547767>]  [<ffffffff81547767>]
>> xfrm_selector_match+0x25/0x2f6
>> [16623.096233] RSP: 0018:ffff88083fc03900  EFLAGS: 00010246
>> [16623.096261] RAX: 0000000000000001 RBX: ffff88083fc03a20 RCX: ffff880787fb1200
>> [16623.096292] RDX: 0000000000000002 RSI: ffff88083fc03a20 RDI: 00000000010600a6
>> [16623.096323] RBP: 00000000010600a6 R08: 0000000000000000 R09: ffff88083fc039a0
>> [16623.096353] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88083fc03a20
>> [16623.096383] R13: 0000000000000001 R14: ffffffff818a9700 R15: ffffffffa01c73e0
>> [16623.096414] FS:  0000000000000000(0000) GS:ffff88083fc00000(0000)
>> knlGS:0000000000000000
>> [16623.096469] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [16623.096498] CR2: 00000000010600d0 CR3: 0000000085f0b000 CR4: 00000000000407f0
>> [16623.096528] Stack:
>> [16623.096550]  0000000000000000 0000000001060002 ffff880787fb1200 ffff88083fc03a20
>> [16623.096602]  0000000000000001 ffffffff81547a7c 0000000000000000 ffff8800baad5480
>> [16623.096655]  ffffffff81804450 ffffffff818a9700 000000003c9041bc ffffffff81547ef7
>> [16623.096721] Call Trace:
>> [16623.096744]  <IRQ>
>> [16623.096749]  [<ffffffff81547a7c>] ? xfrm_sk_policy_lookup+0x44/0x9b
>> [16623.096802]  [<ffffffff81547ef7>] ? xfrm_lookup+0x91/0x446
>> [16623.096832]  [<ffffffff81541316>] ? ip_route_me_harder+0x150/0x1b0
>> [16623.096865]  [<ffffffffa01b6457>] ? ip_vs_route_me_harder+0x86/0x91 [ip_vs]
>> [16623.096899]  [<ffffffffa01b797a>] ? ip_vs_out+0x2d3/0x5bc [ip_vs]
>> [16623.096930]  [<ffffffff81501420>] ? ip_rcv_finish+0x2b8/0x2b8
> 
> I really wonder why the xfrm_sk_policy_lookup codepath is taken here.
> It looks like this is the processing of an inbound ipv4 packet that
> is going to be rerouted to the output path by ipvs, so this packet
> should not have socket context at all.
> 
> xfrm_sk_policy_lookup is called just if the packet has socket context
> and the socket has an IPsec output policy configured. Do you use IPsec
> socket policies?
> 

Yes it is insane i do not know why this happens and i wonder as well - i do not
have IPsec configured. I tried yesterday with only

CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m

and all other XFRM modules disabled, same problem.

I now compiled kernel without xfrm to check if the problem is somewhere else.

I have seen that on this box (debian squeeze) the racoon tool inserts xfrm
polcies like so:

ip xfrm policy show
src ::/0 dst ::/0
        dir 4 priority 0 ptype main
src ::/0 dst ::/0
        dir 3 priority 0 ptype main
src ::/0 dst ::/0
        dir 4 priority 0 ptype main
src ::/0 dst ::/0
        dir 3 priority 0 ptype main
src ::/0 dst ::/0
...

I tried without racoon running and with ipsec userspace tools disabled, but the
problem still exists without ipsec userspace tools.

Interesting is maybe, that the longer the node is running and interfaces are
added to a bridge, the more policies sum up. Here is an overview of other nodes,
but without ipvs running:


Executing  ip  xfrm  policy  show  |  wc  -l  on node02
92
Executing  ip  xfrm  policy  show  |  wc  -l  on node03
92
Executing  ip  xfrm  policy  show  |  wc  -l  on node04
68
Executing  ip  xfrm  policy  show  |  wc  -l  on node05
104
Executing  ip  xfrm  policy  show  |  wc  -l  on node06
160

Executing  uptime  on node02
 17:30:35 up 4 days, 22:56,  0 users,  load average: 1,45, 1,36, 1,25
Executing  uptime  on node03
 17:30:35 up 4 days, 22:48,  1 user,  load average: 1,50, 1,18, 1,12
Executing  uptime  on node04
 17:30:36 up 4 days, 22:41,  5 users,  load average: 1,07, 0,86, 0,80
Executing  uptime  on node05
 17:30:36 up 3 days,  3:24,  1 user,  load average: 1.66, 1.73, 1.82
Executing  uptime  on node06
 17:30:36 up 3 days,  3:15,  1 user,  load average: 1.38, 1.26, 1.30


We have a bridge configured on all nodes, so it seems to me when a devices is
added to a bridge, somehow the xfrm rules are created, but when the device is
remove from the bridge, the xfrm rules stay here.

Executing  brctl  show  on node02
bridge name     bridge id               STP enabled     interfaces
br0             8000.00259052bbf6       no              bond0
                                                        veth31gl4f
                                                        vethhVTC6u
                                                        vnet0
                                                        vnet10
                                                        vnet12
                                                        vnet2
                                                        vnet3
                                                        vnet4
                                                        vnet5
                                                        vnet7
                                                        vnet8
                                                        vnet9
Executing  brctl  show  on node03
bridge name     bridge id               STP enabled     interfaces
br0             8000.00259052bbee       no              bond0
                                                        vethb9trsN
                                                        vethlFKktL
                                                        vnet0
                                                        vnet1
                                                        vnet10
                                                        vnet2
                                                        vnet3
                                                        vnet4
                                                        vnet5
                                                        vnet6
                                                        vnet7
                                                        vnet8
virbr0          8000.000000000000       yes
Executing  brctl  show  on node04
bridge name     bridge id               STP enabled     interfaces
br0             8000.00259052bba8       no              bond0
                                                        veth2z6JHJ
                                                        vethD7kF0Z
                                                        vethZ8UGHJ
                                                        vetho6hc1N
                                                        vethwnIRTH
virbr0          8000.000000000000       yes
Executing  brctl  show  on node05
bridge name     bridge id               STP enabled     interfaces
br0             8000.00199976d512       no              bond0
                                                        vnet0
                                                        vnet1
                                                        vnet10
                                                        vnet11
                                                        vnet12
                                                        vnet14
                                                        vnet15
                                                        vnet2
                                                        vnet4
                                                        vnet5
                                                        vnet6
                                                        vnet7
                                                        vnet9
Executing  brctl  show  on node06
bridge name     bridge id               STP enabled     interfaces
br0             8000.00199976d560       no              bond0
                                                        vnet0
                                                        vnet10
                                                        vnet12
                                                        vnet13
                                                        vnet14
                                                        vnet15
                                                        vnet16
                                                        vnet17
                                                        vnet18
                                                        vnet2
                                                        vnet20
                                                        vnet21
                                                        vnet23
                                                        vnet25
                                                        vnet26
                                                        vnet28
                                                        vnet29
                                                        vnet3
                                                        vnet30
                                                        vnet5
                                                        vnet6
                                                        vnet7
                                                        vnet8
                                                        vnet9
...

I noticed the racoon userspace daemon running wild as corosync moved configured
ip addresses to and from the node, so there could be the possibility that this
is somehow related. Could it be that the polcies are never cleared up somehow?






-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
