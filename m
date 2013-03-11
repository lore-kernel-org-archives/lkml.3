Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3CKUIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab3CKUIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:08:52 -0400
Date: Mon, 11 Mar 2013 17:08:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130311170837.4c987c43@redhat.com>
In-Reply-To: <20130311143138.GC5000@pd.tnic>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
	<20130311092848.652c0d46@redhat.com>
	<20130311134814.GB5000@pd.tnic>
	<20130311111215.3f12e9ee@redhat.com>
	<20130311143138.GC5000@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Em Mon, 11 Mar 2013 15:31:38 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Mar 11, 2013 at 11:12:15AM -0300, Mauro Carvalho Chehab wrote:
> > Ok, I'll test it on a K8 box at RH.
> >
> > The bug seems to be on K8 rev F, right? Is there a different PCI ID on
> > those machines? That would help me to quickly find such machine on at
> > RH labs.
> 
> K8 revF should be a good choice, yes. Anything with model >= 40 in
> /proc/cpuinfo.

Tests done and it looks alright.

I've applied this Fedora18 Kernel with the patches applied on it:

	http://koji.fedoraproject.org/koji/taskinfo?taskID=5107290

The machine I took is an HP xw4550, using a dual-core CPU, with those
CPU info:

vendor_id	: AuthenticAMD
cpu family	: 15
model		: 67
model name	: Dual-Core AMD Opteron(tm) Processor 1214 HE
stepping	: 3
microcode	: 0x6d

The EDAC dmesg is:

[   26.763384] EDAC MC: Ver: 3.0.0
[   26.769214] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   26.803556] AMD64 EDAC driver v3.4.0
[   26.807289] EDAC amd64: DRAM ECC enabled.
[   26.811379] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   26.811382] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   26.811393] EDAC amd64: K8 revF or later detected (node 0).
[   26.816973] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   26.816975] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   26.816977] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   26.816980] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x0000000080000000
[   26.816982] EDAC DEBUG: read_mc_regs:   TOP_MEM2 disabled
[   26.816986] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000007fffffff
[   26.816989] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   26.816998] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   26.817001] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   26.817019] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000101 reg: F2x48
[   26.817022] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000000 reg: F2x4c
[   26.817026] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   26.817030] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   26.817035] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   26.817038] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   26.817041] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00783ee0 reg: F2x60
[   26.817044] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00783ee0 reg: F2x64
[   26.817046] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   26.817049] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   26.817055] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   26.817057] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   26.817059] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   26.817061] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090c10
[   26.817064] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   26.817066] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   26.817068] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   26.817071] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   26.817073] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0x00000000, base: 0x00000000, offset: 0x00000000
[   26.817075] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
[   26.817078] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   26.817080] EDAC MC: DCT0 chip selects:
[   26.817083] EDAC amd64: MC: 0:  1024MB 1:     0MB
[   26.821788] EDAC amd64: MC: 2:  1024MB 3:     0MB
[   26.826489] EDAC amd64: MC: 4:     0MB 5:     0MB
[   26.831187] EDAC amd64: MC: 6:     0MB 7:     0MB
[   26.835887] EDAC DEBUG: edac_mc_alloc: allocating 2112 bytes for mci data (16 ranks, 16 csrows/channels)
[   26.836348] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   26.836351] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   26.836353] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, DBAM idx: 2
[   26.836356] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.836358] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   26.840973] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   26.840976] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   26.840981] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 2
[   26.840982] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.840984] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   26.845600] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   26.845604] EDAC DEBUG: edac_mc_add_mc: 
[   26.845620] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   26.845863] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   26.846696] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   26.847134] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   26.847138] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm1, located at csrow 0 channel 1 
[   26.847556] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank1
[   26.847559] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   26.847954] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   26.847957] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   26.848380] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   26.848404] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   26.849538] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   26.850420] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   26.857965] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   26.857981] EDAC DEBUG: edac_pci_add_device: 
[   26.857984] EDAC DEBUG: add_edac_pci_to_global_list: 
[   26.857986] EDAC DEBUG: find_edac_pci_by_dev: 
[   26.857988] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   26.857990] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   26.858992] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   26.858994] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   26.859193] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   26.859210] EDAC DEBUG: edac_pci_workq_setup: 
[   26.859216] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)

The memory arrangement is:

Memory Device
	Array Handle: 0x002E
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM2A
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
--
Memory Device
	Array Handle: 0x002E
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM2B
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
--
Memory Device
	Array Handle: 0x002E
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM1A
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
--
Memory Device
	Array Handle: 0x002E
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM1B
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous


The EDAC memory size sysfs nodes:

/sys/devices/system/edac/mc/mc0/size_mb:2048

/sys/devices/system/edac/mc/mc0/rank0/size:512
/sys/devices/system/edac/mc/mc0/rank1/size:512
/sys/devices/system/edac/mc/mc0/rank4/size:512
/sys/devices/system/edac/mc/mc0/rank5/size:512

/sys/devices/system/edac/mc/mc0/csrow0/size_mb:1024
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:1024

While this machine is reserved for my usage, do you need a different
test on it?

Regards,
Mauro
