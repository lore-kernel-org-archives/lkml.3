Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3CGJhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:37:17 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46095 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3CGJhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:37:12 -0500
Date: Thu, 7 Mar 2013 04:37:11 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
Subject: 3.9-rc1 NULL pointer crash at find_pid_ns
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just came across this during LTP run on a ppc64 system. Still trying to
reproduce and possible bisect, but want to give an early head-up to see
if anyone see anything obvious.

CAI Qian

[ 6476.040024] Unable to handle kernel paging request for data at address 0xfffffffffffffff0 
[ 6476.040051] Faulting instruction address: 0xc0000000000af8ac 
[ 6476.040060] Oops: Kernel access of bad area, sig: 11 [#1] 
[ 6476.040067] SMP NR_CPUS=1024 NUMA pSeries 
[ 6476.040077] Modules linked in: tun binfmt_misc hidp cmtp kernelcapi rfcomm l2tp_ppp l2tp_netlink l2tp_core bnep nfc af_802154 pppoe pppox ppp_generic slhc rds af_key atm sctp ip6table_filter ip6_tables iptable_filter ip_tables btrfs raid6_pq xor vfat fat nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse sg ehea xfs libcrc32c sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipt_REJECT] 
[ 6476.040204] NIP: c0000000000af8ac LR: c0000000000b07e0 CTR: 0000000000000000 
[ 6476.040213] REGS: c00000011ae73480 TRAP: 0300   Not tainted  (3.9.0-rc1) 
[ 6476.040221] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 88008488  XER: 20000000 
[ 6476.040243] SOFTE: 1 
[ 6476.040248] CFAR: c000000000005f1c 
[ 6476.040253] DAR: fffffffffffffff0, DSISR: 40000000 
[ 6476.040260] TASK = c00000006be719e0[26514] 'ps' THREAD: c00000011ae70000 CPU: 26 
GPR00: c000000000299c34 c00000011ae73700 c0000000010f3a18 00000000000050d5  
GPR04: c000000001047ec0 0000000000000011 a000000000000000 9e97fbecc2b0cf95  
GPR08: c0000001472521c0 fffffffffffffff0 c0000000014d0000 c000000144886026  
GPR12: 0000000024008422 c00000000ed96800 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000  
GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000011ae73ab0  
GPR24: c00000014488602b 0000000000000000 0000000000000004 fffffffffffff000  
GPR28: c0000001fd040040 c0000001fd040040 c0000001f2ed3540 0000000000000011  
[ 6476.040371] NIP [c0000000000af8ac] .find_pid_ns+0x8c/0xd0 
[ 6476.040379] LR [c0000000000b07e0] .find_task_by_pid_ns+0x10/0x50 
[ 6476.040385] Call Trace: 
[ 6476.040394] [c00000011ae73700] [c00000011ae737c0] 0xc00000011ae737c0 (unreliable) 
[ 6476.040407] [c00000011ae73770] [c000000000299c34] .proc_pid_lookup+0xc4/0x1a0 
[ 6476.040416] [c00000011ae73800] [c0000000002942f4] .proc_root_lookup+0x44/0x80 
[ 6476.040427] [c00000011ae73890] [c00000000021b300] .lookup_real+0x40/0x90 
[ 6476.040437] [c00000011ae73910] [c00000000021bd00] .__lookup_hash+0x40/0x60 
[ 6476.040446] [c00000011ae739a0] [c00000000021c7d0] .lookup_slow+0x60/0x100 
[ 6476.040456] [c00000011ae73a30] [c00000000021da08] .link_path_walk+0x8d8/0xaa0 
[ 6476.040466] [c00000011ae73b40] [c000000000221a98] .path_openat+0xc8/0x5c0 
[ 6476.040476] [c00000011ae73c60] [c0000000002223f0] .do_filp_open+0x40/0xb0 
[ 6476.040486] [c00000011ae73d80] [c00000000020d470] .do_sys_open+0x140/0x250 
[ 6476.040497] [c00000011ae73e30] [c000000000009c54] syscall_exit+0x0/0x98 
[ 6476.040504] Instruction dump: 
[ 6476.040510] 7d2a482a 3929fff0 48000020 60000000 60000000 e9490010 2faa0000 419e0048  
[ 6476.040528] e9290010 3929fff0 2fa90000 419e0038 <81490000> 7f8a1800 409effdc e9490008  
[ 6476.040551] ---[ end trace 5c3fc2ac5c10d1e8 ]--- 
[ 6476.042165]  
