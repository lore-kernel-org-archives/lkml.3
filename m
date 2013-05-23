Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3EWDWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:22:30 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52416 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3EWDW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:22:29 -0400
Date: Wed, 22 May 2013 23:22:25 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, stable@vger.kernel.org
Message-ID: <1428092945.4998810.1369279345727.JavaMail.root@redhat.com>
In-Reply-To: <20130522153024.GA10402@kroah.com>
References: <1889683289.4496510.1369211505160.JavaMail.root@redhat.com> <519C848D.3080401@huawei.com> <20130522153024.GA10402@kroah.com>
Subject: Re: 3.9.2: trinity triggered oops
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2: trinity triggered oops
Thread-Index: N+pBT8xgwM/s9O6z/gtsXmH7PKnkEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Li Zefan" <lizefan@huawei.com>, "LKML" <linux-kernel@vger.kernel.org>, "Dave Jones" <davej@redhat.com>,
> stable@vger.kernel.org
> Sent: Wednesday, May 22, 2013 11:30:24 PM
> Subject: Re: 3.9.2: trinity triggered oops
> 
> On Wed, May 22, 2013 at 04:40:45PM +0800, Li Zefan wrote:
> > On 2013/5/22 16:31, CAI Qian wrote:
> > > Reproduced on a few systems.
> > > CAI Qian
> > > 
> > > created 375 sockets
> > > Generating file descriptors
> > > Added 45 filenames from /dev
> > > Added 19858 filenames from /proc
> > > Added 11816 filenames from /sys
> > > [1143] Random reseed: 1433907474
> > > trinity(1143): Randomness reseeded to 0x5577b112
> > > trinity: trinity(1143) Randomness reseeded to 0x5577b112
> > > msgrcv (70) returned ENOSYS, marking as inactive.
> > > uselib (134) returned ENOSYS, marking as inactive.
> > > [1143] Random reseed: 801659033
> > > trinity(1143): Randomness reseeded to 0x2fc85899
> > > trinity: trinity(1143) Randomness reseeded to 0x2fc85899
> > > nfsservctl (180) returned ENOSYS, marking as inactive.
> > > kcmp (312) returned ENOSYS, marking as inactive.
> > > [watchdog] 1329 iterations. [F:1158 S:168]
> > > [1143] Random reseed: 715320073
> > > trinity(1143): Randomness reseeded to 0x2aa2eb09
> > > trinity: trinity(1143) Randomness reseeded to 0x2aa2eb09
> > > [watchdog] 3567 iterations. [F:3060 S:506]
> > > [watchdog] 4953 iterations. [F:4255 S:697]
> > > [ 4508.627400] BUG: unable to handle kernel NULL pointer dereference at
> > > 0000000000000008
> > > [ 4508.670547] IP: [<ffffffff81286682>] newseg+0x102/0x310
> > > [ 4508.698846] PGD 18d827067 PUD 19a85f067 PMD 0
> > > [ 4508.723288] Oops: 0000 [#1] SMP
> > > [ 4508.741135] Modules linked in: ipt_ULOG(F) scsi_transport_iscsi(F)
> > > pppoe(F) pppox(F) ppp_generic(F) slhc(F) af_key(F) nfc(F) af_802154(F)
> > > atm(F) rds(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F)
> > > nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) fscache(F)
> > > nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F)
> > > nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F)
> > > nls_cp932(F) ts_kmp(F) sctp(F) nf_conntrack_netbios_ns(F)
> > > nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F)
> > > nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F)
> > > nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F)
> > > iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F)
> > > xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
> > > ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F)
> > > iTCO_wdt(F) iTCO_vendor_support(F) e1000e(F) bnx2x(F) hpwdt(F) ptp(F)
> > > mdio(F) hpilo(F) serio_raw(F) lpc_ich(F) pps_core(F)!
> >  p!
> > > cspkr(F) mfd_core(F) microcode(F) xfs(F) libcrc32c(F) ata_generic(F)
> > > mgag200(F) pata_acpi(F) i2c_algo_bit(F) sd_mod(F) ata_piix(F)
> > > drm_kms_helper(F) ttm(F) crc_t10dif(F) drm(F) hpsa(F) libata(F)
> > > i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last
> > > unloaded: brd]
> > > [ 4509.308340] CPU 3
> > > [ 4509.318654] Pid: 4068, comm: trinity-child2 Tainted: GF
> > > 3.9.2 #1 HP ProLiant DL120 G7
> > > [ 4509.363440] RIP: 0010:[<ffffffff81286682>]  [<ffffffff81286682>]
> > > newseg+0x102/0x310
> > 
> > The fix has already been queued for 3.9.3.
> > 
> > commit 091d0d55b286c9340201b4ed4470be87fc568228
> > ("shm: fix null pointer deref when userspace specifies invalid hugepage
> > size")
> 
> Yes, can you please test 3.9.3 to verify that this is fixed?
Yes, I am never running into this again in 3.9.3 so far. I'll keep an eye
on it though.
CAI Qian
> 
> thanks,
> 
> greg k-h
> 
