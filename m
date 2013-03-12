Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3CLL0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab3CLL0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:26:43 -0400
Date: Tue, 12 Mar 2013 08:26:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312082629.4529e645@redhat.com>
In-Reply-To: <20130311204303.GG5000@pd.tnic>
References: <20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
	<20130311092848.652c0d46@redhat.com>
	<20130311134814.GB5000@pd.tnic>
	<20130311111215.3f12e9ee@redhat.com>
	<20130311143138.GC5000@pd.tnic>
	<20130311170837.4c987c43@redhat.com>
	<20130311204303.GG5000@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 11 Mar 2013 21:43:03 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Mar 11, 2013 at 05:08:37PM -0300, Mauro Carvalho Chehab wrote:
> > While this machine is reserved for my usage, do you need a different
> > test on it?
> 
> Yes please. Can you send dmesg and sysfs entries before applying your
> patches?
> 
> Thanks.
> 

Sorry to take a longer time. I had some troubles with the KVM remote access
on that machine.

Those are the logs before the patch:

[   25.948433] EDAC MC: Ver: 3.0.0
[   25.955808] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   25.981798] AMD64 EDAC driver v3.4.0
[   25.998314] EDAC amd64: DRAM ECC enabled.
[   26.002384] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   26.002387] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   26.002410] EDAC amd64: K8 revF or later detected (node 0).
[   26.008122] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   26.008125] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   26.008127] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   26.008130] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x0000000080000000
[   26.008132] EDAC DEBUG: read_mc_regs:   TOP_MEM2 disabled
[   26.008139] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000007fffffff
[   26.008142] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   26.008161] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   26.008164] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   26.008168] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000101 reg: F2x48
[   26.008171] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000000 reg: F2x4c
[   26.008175] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   26.008178] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   26.008182] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   26.008185] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   26.008189] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00783ee0 reg: F2x60
[   26.008193] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00783ee0 reg: F2x64
[   26.008196] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   26.008200] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   26.008208] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   26.008210] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   26.008212] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   26.008215] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090c10
[   26.008217] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   26.008220] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   26.008222] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   26.008224] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   26.008227] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0x00000000, base: 0x00000000, offset: 0x00000000
[   26.008229] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
[   26.008232] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   26.008234] EDAC MC: DCT0 chip selects:
[   26.008236] EDAC amd64: MC: 0:  1024MB 1:     0MB
[   26.012951] EDAC amd64: MC: 2:  1024MB 3:     0MB
[   26.017659] EDAC amd64: MC: 4:     0MB 5:     0MB
[   26.022370] EDAC amd64: MC: 6:     0MB 7:     0MB
[   26.027080] EDAC DEBUG: edac_mc_alloc: allocating 2112 bytes for mci data (16 ranks, 16 csrows/channels)
[   26.035885] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   26.035888] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   26.035891] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, DBAM idx: 2
[   26.035893] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.035895] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   26.040538] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   26.040540] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   26.040543] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 2
[   26.040545] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.040546] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   26.045254] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   26.045257] EDAC DEBUG: edac_mc_add_mc: 
[   26.045452] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   26.046249] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   26.047042] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   26.047662] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   26.047665] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm1, located at csrow 0 channel 1 
[   26.048322] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank1
[   26.048325] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   26.048873] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   26.048876] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   26.049538] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   26.049574] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   26.050231] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   26.051543] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   26.059204] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   26.059224] EDAC DEBUG: edac_pci_add_device: 
[   26.059309] EDAC DEBUG: add_edac_pci_to_global_list: 
[   26.059311] EDAC DEBUG: find_edac_pci_by_dev: 
[   26.059313] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   26.059315] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   26.059568] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   26.059570] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   26.059653] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   26.062526] EDAC DEBUG: edac_pci_workq_setup: 
[   26.062775] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)

And those are the sysfs size nodes:

# grep .  $(find /sys/devices/system/edac/ -name size*)
/sys/devices/system/edac/mc/mc0/rank0/size:1024
/sys/devices/system/edac/mc/mc0/rank1/size:1024
/sys/devices/system/edac/mc/mc0/rank4/size:1024
/sys/devices/system/edac/mc/mc0/rank5/size:1024
/sys/devices/system/edac/mc/mc0/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow0/size_mb:1024
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:1024

-- 

Cheers,
Mauro
