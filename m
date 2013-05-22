Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3EVIbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:31:49 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56535 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3EVIbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:31:45 -0400
Date: Wed, 22 May 2013 04:31:45 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>, stable@vger.kernel.org
Message-ID: <1889683289.4496510.1369211505160.JavaMail.root@redhat.com>
In-Reply-To: <831075050.4496351.1369211475134.JavaMail.root@redhat.com>
Subject: 3.9.2: trinity triggered oops
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2: trinity triggered oops
Thread-Index: L/JcfJbteX5TuBXeGRtfS2JpuYin8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reproduced on a few systems.
CAI Qian

created 375 sockets 
Generating file descriptors 
Added 45 filenames from /dev 
Added 19858 filenames from /proc 
Added 11816 filenames from /sys 
[1143] Random reseed: 1433907474 
trinity(1143): Randomness reseeded to 0x5577b112 
trinity: trinity(1143) Randomness reseeded to 0x5577b112 
msgrcv (70) returned ENOSYS, marking as inactive. 
uselib (134) returned ENOSYS, marking as inactive. 
[1143] Random reseed: 801659033 
trinity(1143): Randomness reseeded to 0x2fc85899 
trinity: trinity(1143) Randomness reseeded to 0x2fc85899 
nfsservctl (180) returned ENOSYS, marking as inactive. 
kcmp (312) returned ENOSYS, marking as inactive. 
[watchdog] 1329 iterations. [F:1158 S:168] 
[1143] Random reseed: 715320073 
trinity(1143): Randomness reseeded to 0x2aa2eb09 
trinity: trinity(1143) Randomness reseeded to 0x2aa2eb09 
[watchdog] 3567 iterations. [F:3060 S:506] 
[watchdog] 4953 iterations. [F:4255 S:697] 
[ 4508.627400] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008 
[ 4508.670547] IP: [<ffffffff81286682>] newseg+0x102/0x310 
[ 4508.698846] PGD 18d827067 PUD 19a85f067 PMD 0  
[ 4508.723288] Oops: 0000 [#1] SMP  
[ 4508.741135] Modules linked in: ipt_ULOG(F) scsi_transport_iscsi(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) af_key(F) nfc(F) af_802154(F) atm(F) rds(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F) nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) sctp(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) iTCO_vendor_support(F) e1000e(F) bnx2x(F) hpwdt(F) ptp(F) mdio(F) hpilo(F) serio_raw(F) lpc_ich(F) pps_core(F) pcspkr(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) ata_generic(F) mgag200(F) pata_acpi(F) i2c_algo_bit(F) sd_mod(F) ata_piix(F) drm_kms_helper(F) ttm(F) crc_t10dif(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: brd] 
[ 4509.308340] CPU 3  
[ 4509.318654] Pid: 4068, comm: trinity-child2 Tainted: GF            3.9.2 #1 HP ProLiant DL120 G7 
[ 4509.363440] RIP: 0010:[<ffffffff81286682>]  [<ffffffff81286682>] newseg+0x102/0x310 
[ 4509.401795] RSP: 0018:ffff8801ab009e88  EFLAGS: 00010246 
[ 4509.427958] RAX: 0000000000000000 RBX: ffffffff8197b240 RCX: 0000000000000009 
[ 4509.463783] RDX: ffffffff81d63338 RSI: 0000000000001000 RDI: 0000000010000000 
[ 4509.499290] RBP: ffff8801ab009ed8 R08: 0000000000000010 R09: 000000000000001c 
[ 4509.535044] R10: 0000000000000000 R11: 000000000000000f R12: 0000000000001001 
[ 4509.571219] R13: ffff8801b8181460 R14: 00000000722cae77 R15: 000000007df2570b 
[ 4509.607233] FS:  00007fdbc6bf7740(0000) GS:ffff88020f460000(0000) knlGS:0000000000000000 
[ 4509.648291] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 4509.677448] CR2: 0000000000000008 CR3: 000000019a856000 CR4: 00000000000407e0 
[ 4509.712725] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[ 4509.751540] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[ 4509.789290] Process trinity-child2 (pid: 4068, threadinfo ffff8801ab008000, task ffff8802007b0000) 
[ 4509.838164] Stack: 
[ 4509.849066]  0000001c00000000 0000000000000002 3756535953000000 0062303735326664 
[ 4509.886160]  00000000913099dc 00000000fffffffe 0000000000000001 ffffffff8197b2f8 
[ 4509.923131]  0000000000000001 ffff8801b23ba6a8 ffff8801ab009f40 ffffffff81282adc 
[ 4509.959682] Call Trace: 
[ 4509.971710]  [<ffffffff81282adc>] ipcget+0x17c/0x1c0 
[ 4509.996384]  [<ffffffff81286f0a>] sys_shmget+0x5a/0x60 
[ 4510.021725]  [<ffffffff81286580>] ? shm_security+0x10/0x10 
[ 4510.049611]  [<ffffffff81286570>] ? shm_close+0xd0/0xd0 
[ 4510.075500]  [<ffffffff812863a0>] ? shm_get_unmapped_area+0x20/0x20 
[ 4510.107046]  [<ffffffff816189d9>] system_call_fastpath+0x16/0x1b 
[ 4510.136619] Code: 00 00 0f 84 e9 00 00 00 45 89 f1 41 c1 e9 1a 45 85 c9 0f 85 31 01 00 00 8b 05 3b 3d ae 00 48 69 c0 78 70 00 00 48 05 c0 c2 d5 81 <8b> 48 08 b8 00 10 00 00 4c 89 f2 48 c1 e2 09 48 8d 7d c3 41 b8  
[ 4510.231305] RIP  [<ffffffff81286682>] newseg+0x102/0x310 
[ 4510.258711]  RSP <ffff8801ab009e88> 
[ 4510.277488] CR2: 0000000000000008 
[watchdog] 7096 iterations. [F:6109 S:986] 
[ 4510.351897] ---[ end trace 4eaee96d0aeec2cb ]--- 
[watchdog] 7117 iterations. [F:6126 S:989] 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510503 now:1368510533 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510505 now:1368510535 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510503 now:1368510564 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510505 now:1368510566 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510505 now:1368510566 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510505 now:1368510566 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510564 now:1368510594 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510566 now:1368510596 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[-- MARK -- Tue May 14 01:50:00 2013] 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510564 now:1368510625 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510566 now:1368510627 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510566 now:1368510627 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510566 now:1368510627 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510625 now:1368510655 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510627 now:1368510657 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510625 now:1368510686 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510627 now:1368510688 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510627 now:1368510688 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510627 now:1368510688 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510686 now:1368510716 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510688 now:1368510718 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510686 now:1368510747 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510688 now:1368510749 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510688 now:1368510749 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510688 now:1368510749 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510747 now:1368510777 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510749 now:1368510779 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510747 now:1368510808 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510749 now:1368510810 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510749 now:1368510810 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510749 now:1368510810 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510808 now:1368510838 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510810 now:1368510840 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510808 now:1368510869 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510810 now:1368510871 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510810 now:1368510871 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510810 now:1368510871 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510869 now:1368510899 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[-- MARK -- Tue May 14 01:55:00 2013] 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510871 now:1368510901 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510869 now:1368510930 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510871 now:1368510932 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510871 now:1368510932 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510871 now:1368510932 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510930 now:1368510960 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510932 now:1368510962 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510930 now:1368510991 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510932 now:1368510993 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510932 now:1368510993 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510932 now:1368510993 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368510991 now:1368511021 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368510993 now:1368511023 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368510991 now:1368511052 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368510993 now:1368511054 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368510993 now:1368511054 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368510993 now:1368511054 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368511052 now:1368511082 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368511054 now:1368511084 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] Triggering periodic reseed. 
[watchdog] pid 4068 hasn't made progress in 60 seconds! (last:1368511052 now:1368511113 diff:61) 
[watchdog] pid 4072 hasn't made progress in 60 seconds! (last:1368511054 now:1368511115 diff:61) 
[watchdog] pid 4111 hasn't made progress in 60 seconds! (last:1368511054 now:1368511115 diff:61) 
[watchdog] pid 4071 hasn't made progress in 60 seconds! (last:1368511054 now:1368511115 diff:61) 
[watchdog] pid 4068 hasn't made progress in 30 seconds! (last:1368511113 now:1368511143 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL. 
[watchdog] pid 4072 hasn't made progress in 30 seconds! (last:1368511115 now:1368511145 diff:30). Stuck in syscall 29:shmget. Sending SIGKILL.
