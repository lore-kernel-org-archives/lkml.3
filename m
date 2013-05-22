Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3EVIlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:41:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:14081 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3EVIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:41:30 -0400
Message-ID: <519C848D.3080401@huawei.com>
Date: Wed, 22 May 2013 16:40:45 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        <stable@vger.kernel.org>
Subject: Re: 3.9.2: trinity triggered oops
References: <1889683289.4496510.1369211505160.JavaMail.root@redhat.com>
In-Reply-To: <1889683289.4496510.1369211505160.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 16:31, CAI Qian wrote:
> Reproduced on a few systems.
> CAI Qian
> 
> created 375 sockets 
> Generating file descriptors 
> Added 45 filenames from /dev 
> Added 19858 filenames from /proc 
> Added 11816 filenames from /sys 
> [1143] Random reseed: 1433907474 
> trinity(1143): Randomness reseeded to 0x5577b112 
> trinity: trinity(1143) Randomness reseeded to 0x5577b112 
> msgrcv (70) returned ENOSYS, marking as inactive. 
> uselib (134) returned ENOSYS, marking as inactive. 
> [1143] Random reseed: 801659033 
> trinity(1143): Randomness reseeded to 0x2fc85899 
> trinity: trinity(1143) Randomness reseeded to 0x2fc85899 
> nfsservctl (180) returned ENOSYS, marking as inactive. 
> kcmp (312) returned ENOSYS, marking as inactive. 
> [watchdog] 1329 iterations. [F:1158 S:168] 
> [1143] Random reseed: 715320073 
> trinity(1143): Randomness reseeded to 0x2aa2eb09 
> trinity: trinity(1143) Randomness reseeded to 0x2aa2eb09 
> [watchdog] 3567 iterations. [F:3060 S:506] 
> [watchdog] 4953 iterations. [F:4255 S:697] 
> [ 4508.627400] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008 
> [ 4508.670547] IP: [<ffffffff81286682>] newseg+0x102/0x310 
> [ 4508.698846] PGD 18d827067 PUD 19a85f067 PMD 0  
> [ 4508.723288] Oops: 0000 [#1] SMP  
> [ 4508.741135] Modules linked in: ipt_ULOG(F) scsi_transport_iscsi(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) af_key(F) nfc(F) af_802154(F) atm(F) rds(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F) nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) sctp(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) iTCO_wdt(F) iTCO_vendor_support(F) e1000e(F) bnx2x(F) hpwdt(F) ptp(F) mdio(F) hpilo(F) serio_raw(F) lpc_ich(F) pps_core(F)!
 p!
> cspkr(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) ata_generic(F) mgag200(F) pata_acpi(F) i2c_algo_bit(F) sd_mod(F) ata_piix(F) drm_kms_helper(F) ttm(F) crc_t10dif(F) drm(F) hpsa(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: brd] 
> [ 4509.308340] CPU 3  
> [ 4509.318654] Pid: 4068, comm: trinity-child2 Tainted: GF            3.9.2 #1 HP ProLiant DL120 G7 
> [ 4509.363440] RIP: 0010:[<ffffffff81286682>]  [<ffffffff81286682>] newseg+0x102/0x310 

The fix has already been queued for 3.9.3.

commit 091d0d55b286c9340201b4ed4470be87fc568228
("shm: fix null pointer deref when userspace specifies invalid hugepage size")

