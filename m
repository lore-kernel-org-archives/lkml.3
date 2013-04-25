Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3DYKU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:20:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38847 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab3DYKUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:20:22 -0400
Date: Thu, 25 Apr 2013 18:20:16 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BTRFS] kernel BUG at fs/btrfs/tree-log.c:1973! in 3.9-rc7
Message-ID: <20130425102016.GA4441@localhost.localdomain>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042510-7182-0000-0000-00000664FBE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We encountered this problem on 3.9-rc7, powerpc 7 system. When they trying to mount a
btrfs partition, kernel paniced with these messages:

============================================================

aimlp6 login: ------------[ cut here ]------------
cpu 0x3: Vector: 700 (Program Check) at [c00000018461afd0]
    pc: d000000006c6ffb4: .replay_one_buffer+0x47c/0x5f8 [btrfs]
    lr: d000000006c6ffb4: .replay_one_buffer+0x47c/0x5f8 [btrfs]
    sp: c00000018461b250
   msr: 8000000000029032
  current = 0xc0000001853a3ae0
  paca    = 0xc000000007f40900   softe: 0        irq_happened: 0x01
    pid   = 8534, comm = mount
kernel BUG at fs/btrfs/tree-log.c:1973!
enter ? for help
[c00000018461b370] d000000006c6a29c .walk_down_log_tree+0x424/0x660 [btrfs]
[c00000018461b460] d000000006c6aac8 .walk_log_tree+0x120/0x3e0 [btrfs]
[c00000018461b530] d000000006c6d528 .btrfs_recover_log_trees+0x558/0x7c0 [btrfs]
[c00000018461b6c0] d000000006c1b8d8 .open_ctree+0x2098/0x22e0 [btrfs]
[c00000018461b900] d000000006bd8830 .btrfs_fill_super+0x90/0x1b0 [btrfs]
[c00000018461b9c0] d000000006bd92a0 .btrfs_mount+0x440/0x450 [btrfs]
[c00000018461bab0] c0000000001fc788 .mount_fs+0x80/0x218
[c00000018461bb60] c0000000002235ec .vfs_kern_mount+0x7c/0x140
[c00000018461bc00] c000000000223800 .do_new_mount+0x110/0x210
[c00000018461bcc0] c000000000223b74 .do_mount+0x274/0x2b0
[c00000018461bd70] c000000000223c98 .SyS_mount+0xe8/0x118
[c00000018461be30] c000000000009edc syscall_exit+0x0/0xa0
--- Exception: c01 (System Call) at 00003fffa8cf0e6c
SP (3fffed202520) is in userspace
3:mon> X
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: nfsv3 nfs_acl nfs fscache lockd sunrpc af_packet fuse loop ipv6 sg ibmveth ext3 jbd mbcache dm_service_time dm_queue_length dm_round_robin dm_multipath btrfs raid6_pq lzo_compress crc32c libcrc32c xor sd_mod crc_t10dif scsi_dh_alua scsi_dh_rdac scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_snapshot dm_mod ibmvscsi scsi_transport_srp scsi_tgt scsi_mod
NIP: d000000006c6ffb4 LR: d000000006c6ffb4 CTR: c0000000001494c8
REGS: c00000018461afd0 TRAP: 0700   Not tainted  (3.9.0-rc7-0.9-ppc64)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 24022424  XER: 20000001
SOFTE: 1
CFAR: d000000006c6be6c
TASK = c0000001853a3ae0[8534] 'mount' THREAD: c000000184618000 CPU: 3
GPR00: d000000006c6ffb4 c00000018461b250 d000000006ce7480 ffffffffffffffe4
GPR04: c0000000014c2768 c000000180861fd8 0000000000000001 0000000000000000
GPR08: c00000000070d488 c000000000eb0ea8 0000000000000000 0000000000000043
GPR12: c000000180861fd8 c000000007f40900 ffffffffffffffff fffffffffffffffa
GPR16: fffffffffffffffa 0000000000008000 c00000018461b2c0 c00000018461b2d1
GPR20: c00000018461b2c9 0000000000000280 c0000001807c0670 c000000180842188
GPR24: c00000017f931380 0000000000000000 00000000000013d4 c00000017f93a380
GPR28: c00000018461b5e8 0000000000728c2e 00000000000000c7 c0000001807683d0
NIP [d000000006c6ffb4] .replay_one_buffer+0x47c/0x5f8 [btrfs]
LR [d000000006c6ffb4] .replay_one_buffer+0x47c/0x5f8 [btrfs]
Call Trace:
[c00000018461b250] [d000000006c6ffb4] .replay_one_buffer+0x47c/0x5f8 [btrfs] (unreliable)
[c00000018461b370] [d000000006c6a29c] .walk_down_log_tree+0x424/0x660 [btrfs]
[c00000018461b460] [d000000006c6aac8] .walk_log_tree+0x120/0x3e0 [btrfs]
[c00000018461b530] [d000000006c6d528] .btrfs_recover_log_trees+0x558/0x7c0 [btrfs]
[c00000018461b6c0] [d000000006c1b8d8] .open_ctree+0x2098/0x22e0 [btrfs]
[c00000018461b900] [d000000006bd8830] .btrfs_fill_super+0x90/0x1b0 [btrfs]
[c00000018461b9c0] [d000000006bd92a0] .btrfs_mount+0x440/0x450 [btrfs]
[c00000018461bab0] [c0000000001fc788] .mount_fs+0x80/0x218
[c00000018461bb60] [c0000000002235ec] .vfs_kern_mount+0x7c/0x140
[c00000018461bc00] [c000000000223800] .do_new_mount+0x110/0x210
[c00000018461bcc0] [c000000000223b74] .do_mount+0x274/0x2b0
[c00000018461bd70] [c000000000223c98] .SyS_mount+0xe8/0x118
[c00000018461be30] [c000000000009edc] syscall_exit+0x0/0xa0
Instruction dump:
7fe6fb78 7fc7f378 7e489378 4bffd8f9 0b030000 7f9d8800 419e0128 e87c0020
7f64db78 7ee5bb78 e8c10070 4bffbdb1 <0b030000> 4bffff10 60420000 e87c0020
---[ end trace f62eb2547334b678 ]---

============================================================

