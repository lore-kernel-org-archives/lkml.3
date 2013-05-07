Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3EGI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:26:00 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54929 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EGIZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:25:57 -0400
Message-ID: <5188B9DE.5030009@linux.vnet.ibm.com>
Date: Tue, 07 May 2013 13:52:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
        Greg KH <gregkh@linuxfoundation.org>, Borislav Petkov <bp@alien8.de>,
        balbi@ti.com
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com> <1066765392.8155999.1367913293110.JavaMail.root@redhat.com>
In-Reply-To: <1066765392.8155999.1367913293110.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050708-4790-0000-0000-00000830FF3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:24 PM, CAI Qian wrote:
> OK, also saw it on x64,
> 
> [   18.305143] WARNING: at drivers/base/core.c:575 device_create_file+0x82/0xa0() 
> [   18.313208] Write permission without 'store' 
> [   18.317985] Modules linked in: i5000_edac(F+) iTCO_vendor_support(F) coretemp(F) edac_core(F) kvm_intel(F) lpc_ich(F) kvm(F) i5k_amb(F) ptp(F) i2c_i801(F) shpchp(F) mfd_core(F) pps_core(F) microcode(F) pcspkr(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) crc_t10dif(F) cdrom(F) ata_generic(F) pata_acpi(F) mgag200(F) syscopyarea(F) sysfillrect(F) sysimgblt(F) ata_piix(F) i2c_algo_bit(F) drm_kms_helper(F) ttm(F) drm(F) libata(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) 
> [   18.366804] CPU: 0 PID: 355 Comm: systemd-udevd Tainted: GF            3.9.0+ #1 
> [   18.375065] Hardware name: NEC Express800/120Rg-1 [N8100-1242]/MS-9172-02S, BIOS 1.0.5S42 10/05/2006 
> [   18.385360]  0000000000000009 ffff880069917938 ffffffff815f105e ffff880069917978 
> [   18.393800]  ffffffff8104e4f0 ffff8800663099c8 ffffffffa03304a0 ffff8800661cea40 
> [   18.402136] Rquest for unknown module key 'Magrathea: Glacier signing key: cf3c1f5ed7be276234c447dbf4a4a5a83a249db4' err -11 
> [   18.402241]  0000000000000000 ffff8800661cea40 0000000000000000 ffff8800699179d8 
> [   18.402242] Call Trace: 
> [   18.402247]  [<ffffffff815f105e> dump_stack+0x19/0x1b 
> [   18.402251]  [<ffffffff8104e4f0>] warn_slowpath_common+0x70/0xa0 
> [   18.402252]  [<ffffffff8104e5d6>] warn_slowpath_fmt+0x46/0x50 
> [   18.402254]  [<ffffffff813c92d2>] device_create_file+0x82/0xa0 
> [   18.402260]  [<fffffffa032a948>] edac_create_sysfs_mci_device+0x3b8/0x550 [edac_core] 
> [   18.402263]  [<ffffffffa0328574>] edac_mc_add_mc+0xf4/0x260 [edac_core] 
> [   18.402265]  [<ffffffffa0304179>] i5000_probe1+0x859/0xb20 [i5000_edac] 
> [   18.402267]  [<ffffffffa0304471>] i5000_init_one+0x31/0x40 [i5000_edac] 
> [   18.402271]  [<ffffffff8131425b>] local_pci_probe+0x4b/0x80 
> [   18.402272]  [<ffffffff81314571>] pci_device_probe+0x111/0x120 
> [   18.402275]  [<ffffffff813cd58b>] driver_probe_device+0x8b/0x390 
> [   18.402276]  [<ffffffff813cd93b>] __driver_attach+0xab/0xb0 
> [   18.402278]  [<ffffffff813cd890>] ? driver_probe_device+0x390/0x390 
> [   .402279]  [<ffffffff813cb50d>] bus_for_each_dev+0x5d/0xa0 
> [   18.402281]  [<ffffffff813ccece>] driver_attach+0x1e/0x20 
> [   18.402282]  [<ffffffff813cc9fe>] bus_add_driver+0x11e/0x2a0 
> [   18.402284]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
> [   18.402285]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
> [   18.402286]  [<ffffffff813ce007>] driver_register+0x77/0x170 
> [   18.402288]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
> [   18.402289]  [<ffffffffa002f000>] ? 0xffffffffa002efff 
> [   18.402 [<ffffffff813134fc>] __pci_register_driver+0x4c/0x50 
> [   18.402292]  [<ffffffffa002f031>] i5000_init+0x31/0x1000 [i5000_edac] 
> [   18.402295]  [<ffffffff810002ea>] do_one_initcall+0xea/0x1a0 
> [   18.402298]  [<ffffffff810b4464>] le+0x11e4/0x1b00 
> [   18.402300]  [<ffffffff81303f10>] ? ddebug_proc_open+0xc0/0xc0 
> [   18.402303]  [<ffffffff815f7af2>] ? page_fault+0x22/0x30 
> [   18.402305]  [<ffffffff810b4e57>] SyS_init_module+0xd7/0x120 
> [   18.402307]  [<ffffffff815ff942>] sysall_fastpath+0x16/0x1b 
> [   18.402308] ---[ end trace 3eb6a6f51fb8cafb ]--- 
> [   18.402406] ------------[ cut here ]------------ 
> 

For the x86-64 case, does the patch posted here fix the issue?
http://marc.info/?l=linux-edac&m=136731542432210&w=2


Regards,
Srivatsa S. Bhat


