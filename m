Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab3DOIaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:30:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427Ab3DOI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:29:59 -0400
Message-ID: <1366014586.4962.17.camel@marge.simpson.net>
Subject: Re: 3.0.60: general protection fault: 0000, Fixing recursive fault
 but reboot is needed
From: Mike Galbraith <bitbucket@online.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Date: Mon, 15 Apr 2013 10:29:46 +0200
In-Reply-To: <20130415053336.GB1155@pcnci.linuxbox.cz>
References: <20130415053336.GB1155@pcnci.linuxbox.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:8gqH1iV7yk3lny415Pt0x/k8tZyFWxQ10B9pAcb2Qop
 8S5Lho7kFpvT6SSwbRwbyjYfXmeOEHeEVzY2dtOn7OcApLhhHI
 GdSdHMn02zUQtnYlRMHGQmzBClEFiLqxGN/xswd2Z06yHJ0TBV
 BXbBp4vpVwU4Ma07kYM2+nj9O7pTrK8+aeZCXhAYvT2ihXiptQ
 YkKUldDkZeWy5+DJqfaWCaaI19N36+bt6AeI24ztOF3+gAE0DU
 STbPsGlaCm2mm3bOPOavpQm40hSqdZhDGjhIkIbQQt4eLMA3J7
 NjavBX32DqM2w0XeH8bSYfizaw74gzHzoRbKHpL5DubJ6PMPsB
 jJOrgaAkVu5K1VumGxUnQHXzBFoJOZ/YjRn9Mf7m2A3xjCeREz
 QUuBSo9yoq+TA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 07:33 +0200, Nikola Ciprich wrote:
> Hi,
> 
> one of our servers keeps spitting GPF messages:
> (sorry for long message)
> 
> [34110.179005] general protection fault: 0000 [#1] PREEMPT SMP 
> [34110.185000] CPU 0 
> [34110.186872] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ip6table_filter ip6_tables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM vhost_net macvtap macvlan tun virtio_net virtio virtio_ring kvm_intel kvm sch_htb xt_IMQ imq xt_physdev xt_comment ipt_REDIRECT xt_tcpudp xt_mark xt_multiport xt_conntrack nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables capi ipt_ULOG x_tables nfs lockd auth_rpcgss nfs_acl autofs4 sunrpc bridge stp llc ipv6 ext3 jbd kernelcapi avmfritz mISDNipac mISDN_core joydev processor thermal_sys pcspkr ghes hed i7core_edac edac_core i2c_i801 i2c_core iTCO_wdt e1000e sg usbhid ext4 jbd2 crc16 sd_mod crc_t10dif ehci_hcd arcmsr scsi_mod button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandler]
> [34110.265159] 
> [34110.266744] Pid: 5628, comm: kavupdater Not tainted 3.0.60lb6.01 #1 Supermicro X8SIA/X8SIA
> [34110.276854] RIP: 0010:[<ffffffff8115c730>]  [<ffffffff8115c730>] dup_fd+0x170/0x320
> [34110.284698] RSP: 0018:ffff880230e2bd90  EFLAGS: 00010206
> [34110.290251] RAX: 00000000000007f8 RBX: ffff880040fd9600 RCX: bfffffffffffffff
> [34110.297470] RDX: 0000880233743f00 RSI: 00000000000000ff RDI: 0000000000000800
> [34110.304687] RBP: ffff880230e2bde0 R08: ffff88003c25fe40 R09: 0000000000000003
> [34110.311990] R10: 0000000000000001 R11: 4000000000000000 R12: ffff88003c0f2000
> [34110.319286] R13: ffff88022e92b800 R14: ffff88003c25fa40 R15: 0000000000000100
> [34110.326521] FS:  00007f2badf40700(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
> [34110.334819] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [34110.340651] CR2: 0000000001c5f710 CR3: 00000002300ef000 CR4: 00000000000026e0
> [34110.348015] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 0000000000000003
> [34110.355300] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [34110.362560] Process kavupdater (pid: 5628, threadinfo ffff880230e2a000, task ffff880231c2c5f0)
> [34110.371412] Stack:
> [34110.373507]  0000000000000020 ffff880233753940 ffff880040fd9610 ffff88022eb6a180
> [34110.381260]  00007f2badf409d0 0000000001200011 ffff8800487245f0 0000000000000000
> [34110.389065]  00007f2badf409d0 0000000000000000 ffff880230e2be80 ffffffff8104f77b
> [34110.396941] Call Trace:
> [34110.399478]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
> [34110.405234]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
> [34110.411062]  [<ffffffff8104fe65>] do_fork+0x55/0x380
> [34110.416126]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
> [34110.422304]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
> [34110.428621]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
> [34110.434801]  [<ffffffff8100b358>] sys_clone+0x28/0x30
> [34110.440000]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
> [34110.445253]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b
> [34110.451584] Code: 7e 10 48 8b 71 10 4c 89 c2 e8 ed ba 0a 00 45 85 ff 74 71 41 8d 47 ff 31 f6 41 ba 01 00 00 00 48 8d 3c c5 08 00 00 00 31 c0 eb 15 <f0> 48 ff 42 48 49 89 14 04 48 83 c0 08 83 c6 01 48 39 f8 74 3b 
> [34110.475183] RIP  [<ffffffff8115c730>] dup_fd+0x170/0x320
> [34110.480626]  RSP <ffff880230e2bd90>
> [34110.484409] ---[ end trace 771117da60ee2556 ]---

Feeding that to scripts/decodecode
Code: 7e 10 48 8b 71 10 4c 89 c2 e8 ed ba 0a 00 45 85 ff 74 71 41 8d 47 ff 31 f6 41 ba 01 00 00 00 48 8d 3c c5 08 00 00 00 31 c0 eb 15 <f0> 48 ff 42 48 49 89 14 04 48 83 c0 08 83 c6 01 48 39 f8 74 3b
All code
========
   0:   7e 10                   jle    0x12
   2:   48 8b 71 10             mov    0x10(%rcx),%rsi
   6:   4c 89 c2                mov    %r8,%rdx
   9:   e8 ed ba 0a 00          callq  0xabafb
   e:   45 85 ff                test   %r15d,%r15d
  11:   74 71                   je     0x84
  13:   41 8d 47 ff             lea    -0x1(%r15),%eax
  17:   31 f6                   xor    %esi,%esi
  19:   41 ba 01 00 00 00       mov    $0x1,%r10d
  1f:   48 8d 3c c5 08 00 00    lea    0x8(,%rax,8),%rdi
  26:   00 
  27:   31 c0                   xor    %eax,%eax
  29:   eb 15                   jmp    0x40
  2b:*  f0 48 ff 42 48          lock incq 0x48(%rdx)     <-- trapping instruction
  30:   49 89 14 04             mov    %rdx,(%r12,%rax,1)
  34:   48 83 c0 08             add    $0x8,%rax
  38:   83 c6 01                add    $0x1,%esi
  3b:   48 39 f8                cmp    %rdi,%rax
  3e:   74 3b                   je     0x7b

RDX: 0000880233743f00.. that certainly will go boom.

That's here in dup_fd():
        for (i = open_files; i != 0; i--) {
                struct file *f = *old_fds++;
                if (f) {
                        get_file(f);

It's doing that get_file(), grabbing a reference to all open files in a
loop, but old_fds points off into lala land, so I'd say you must have
memory corruption, and open_files is garbage.  Seeing "One of our
servers..", operative word being "one", I'd tend to suspect heat or such
given the box exploded in this extremely heavily exercised spot.

-Mike

