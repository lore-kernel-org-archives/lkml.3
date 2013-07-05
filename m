Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab3GEJiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:38:14 -0400
Received: from felten-gate.felten-group.com ([217.6.34.2]:1971 "EHLO
	mail.felten-group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3GEJiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:38:12 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2013 05:38:12 EDT
DomainKey-Signature: a=rsa-sha1; s=feltengroup_com; d=felten-group.com;
	c=simple; q=dns; h=from:message-id;
	b=L0ykkaCfGy/uoV353/nN0gIVl/LppbDTCjBE9fZjGbUryBS8xBbKv8XE8bs9
	guafVE25bKvOLH9G0Meu2qDDYxs6aVHXzzSdYYGaiad83JwIZSv+s9GSK
	4STVb+Ak2dGbVt6WBLmo51Y9ADW1Q5bZVM8HPZCu0xCYDywxrsairw=;
X-MDAV-Result: clean
X-MDAV-Processed: mail.felten-group.com, Fri, 05 Jul 2013 11:30:56 +0200
VBR-Info: md=felten-group.com; mc=all; mv=vbr.emailcertification.org;
X-Spam-Processed: mail.felten-group.com, Fri, 05 Jul 2013 11:30:55 +0200
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: feltengmbh.de
X-HashCash: 1:20:130705:md50000008866::yhlcRwjU4Iy08XKU:00003cPw
X-Return-Path: prvs=18985f3c27=Stefan.Sabolowitsch@felten-group.com
X-Envelope-From: Stefan.Sabolowitsch@felten-group.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: Stefan Sabolowitsch <Stefan.Sabolowitsch@felten-group.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: get a kernel crash with kernel 3.10.0-1.el6.elrepo.x86_64
Thread-Topic: get a kernel crash with kernel 3.10.0-1.el6.elrepo.x86_64
Thread-Index: AQHOeWJYPLG3BlrerkGP5mAscL4/iA==
Date: Fri, 5 Jul 2013 09:30:53 +0000
Message-ID: <CDFC5EEC.A5BF%Stefan.Sabolowitsch@felten-group.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [192.168.1.69]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A103AC432F1F14DA7D6DE98AE5AD918@felten-group.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I get a kernel crash with 3.10.0-1.el6.elrepo.x86_64 (on two machines the
same problem).
Never seen on v3.8.x / v3.9x

Any idea ?

Thx
Stefan

-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-

abrt_version:   2.0.8
cmdline:        ro root=/dev/mapper/vg_ipd2-lv_root rd_NO_LUKS rd_NO_MD
SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=vg_ipd2/lv_swap
rd_NO_DM LANG=de_DE.UTF-8  KEYBOARDTYPE=pc KEYTABLE=de
rd_LVM_LV=vg_ipd2/lv_root rhgb quiet
kernel:         3.10.0-1.el6.elrepo.x86_64
time:           Do 04 Jul 2013 16:18:29 GMT

sosreport.tar.xz: Binary file, 1665652 bytes

backtrace:
:WARNING: at drivers/dma/ioat/dca.c:697 ioat3_dca_init+0x1f2/0x200
[ioatdma]()
:ioatdma 0000:00:16.0: APICID_TAG_MAP set incorrectly by BIOS, disabling
DCA
:Modules linked in: ioatdma(+) i7core_edac edac_core igb hwmon dca ptp
pps_core ext4 jbd2 mbcache sd_mod crc_t10dif ahci libahci dm_mirror
dm_region_hash dm_log dm_mod
:CPU: 0 PID: 1943 Comm: modprobe Not tainted 3.10.0-1.el6.elrepo.x86_64 #1
:Hardware name: NEXCOM NSA7110/NSB7110, BIOS 1.43 11/10/2010
:ffffffffa016cbfc ffff8802333efa68 ffffffff815f50e8 ffff8802333efaa8
:ffffffff8105b2f0 ffffffffa016e9c0 ffff8802345da7c0 ffff880234660de0
:ffff880234679000 0000000000000002 0000000000000100 ffff8802333efb08
:Call Trace:
:[<ffffffff815f50e8>] dump_stack+0x19/0x21
:[<ffffffff8105b2f0>] warn_slowpath_common+0x70/0xa0
:[<ffffffff8105b37f>] warn_slowpath_fmt_taint+0x3f/0x50
:[<ffffffffa01139a1>] ? alloc_dca_provider+0x21/0x40 [dca]
:[<ffffffffa016b142>] ioat3_dca_init+0x1f2/0x200 [ioatdma]
:[<ffffffffa01673e0>] ioat3_dma_probe+0x310/0x460 [ioatdma]
:[<ffffffff812ce4cb>] ? __pci_set_master+0x2b/0x90
:[<ffffffffa0163241>] ioat_pci_probe+0x1b1/0x1d0 [ioatdma]
:[<ffffffff812d0e0e>] local_pci_probe+0x4e/0x90
:[<ffffffff812d0f21>] __pci_device_probe+0xd1/0xe0
:[<ffffffff812d2262>] ? pci_dev_get+0x22/0x30
:[<ffffffff812d22aa>] pci_device_probe+0x3a/0x60
:[<ffffffff813cddc1>] really_probe+0x61/0x210
:[<ffffffff813cdfae>] driver_probe_device+0x3e/0x60
:[<ffffffff813ce07b>] __driver_attach+0xab/0xb0
:[<ffffffff813cdfd0>] ? driver_probe_device+0x60/0x60
:[<ffffffff813cdfd0>] ? driver_probe_device+0x60/0x60
:[<ffffffff813cc264>] bus_for_each_dev+0x94/0xb0
:[<ffffffff813cdc0e>] driver_attach+0x1e/0x20
:[<ffffffff813cd658>] bus_add_driver+0x1e8/0x250
:[<ffffffffa0157000>] ? 0xffffffffa0156fff
:[<ffffffff813ce714>] driver_register+0x74/0x160
:[<ffffffffa0157000>] ? 0xffffffffa0156fff
:[<ffffffff812d23bc>] __pci_register_driver+0x4c/0x50
:[<ffffffffa015706d>] ioat_init_module+0x6d/0x1000 [ioatdma]
:[<ffffffff81002042>] do_one_initcall+0x42/0x170
:[<ffffffff810c3a30>] do_init_module+0x80/0x1f0
:[<ffffffff810c5540>] load_module+0x390/0x500
:[<ffffffff810c3110>] ? mod_sysfs_teardown+0x150/0x150
:[<ffffffff810c31a7>] ? copy_module_from_user+0x67/0xc0
:[<ffffffff810c2830>] ? module_sect_show+0x30/0x30
:[<ffffffff810c57f3>] SyS_init_module+0x93/0xa0
:[<ffffffff816014d9>] system_call_fastpath+0x16/0x1b








