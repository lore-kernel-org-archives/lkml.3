Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3CGOCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:02:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3CGOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:02:30 -0500
Date: Thu, 7 Mar 2013 11:02:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130307110213.7a5a9978@redhat.com>
In-Reply-To: <20130307130635.GD5239@pd.tnic>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 7 Mar 2013 14:06:35 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Mar 07, 2013 at 09:57:03AM -0300, Mauro Carvalho Chehab wrote:
> > After running my edac testbanch on an AMD64 machine, populated
> > with 4 DIMMS, each being a 4GB QUAD-rank DIMMs, the EDAC driver
> > reported 4 different memory configurations ;)
> 
> Can you please enable CONFIG_EDAC_DEBUG and send me dmesg?

Sure. See below:

[   19.062902] EDAC MC: Ver: 3.0.0
[   19.088757] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   19.284745] AMD64 EDAC driver v3.4.0
[   19.299082] EDAC amd64: DRAM ECC enabled.
[   19.315960] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321115] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 2, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321118] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 3, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321120] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 4, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321123] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 5, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321125] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 6, MCG_CTL: 0x3f, NB MSR is enabled
[   19.321140] EDAC amd64: F10h detected (node 0).
[   19.327072] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   19.327074] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   19.327076] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   19.327078] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
[   19.327081] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000420000000
[   19.327087] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
[   19.327089] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode
[   19.327091] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
[   19.327093] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
[   19.327095] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
[   19.327099] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000021fffffff
[   19.327101] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   19.327104] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000220000000; limit: 0x000000041fffffff
[   19.327107] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
[   19.327114] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000000 reg: F2x40
[   19.327117] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000000 reg: F2x140
[   19.327119] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   19.327121] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000000 reg: F2x144
[   19.327123] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000001 reg: F2x48
[   19.327125] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000001 reg: F2x148
[   19.327129] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000101 reg: F2x4c
[   19.327131] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000101 reg: F2x14c
[   19.327134] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   19.327136] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
[   19.327138] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   19.327140] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
[   19.327142] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000201 reg: F2x58
[   19.327144] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000201 reg: F2x158
[   19.327146] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000301 reg: F2x5c
[   19.327148] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000301 reg: F2x15c
[   19.327150] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00000000 reg: F2x60
[   19.327152] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x00000000 reg: F2x160
[   19.327155] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   19.327157] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x00f83ce0 reg: F2x164
[   19.327159] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   19.327161] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
[   19.327163] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00f83ce0 reg: F2x6c
[   19.327165] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00f83ce0 reg: F2x16c
[   19.327169] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x0200df5f
[   19.327170] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   19.327172] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   19.327175] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00080100
[   19.327179] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   19.327181] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   19.327183] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   19.327185] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   19.327187] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   19.327189] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0002003, base: 0xe0000000, offset: 0x20000000
[   19.327190] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
[   19.327193] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00005050
[   19.327195] EDAC MC: DCT0 chip selects:
[   19.327196] EDAC amd64: MC: 0:     0MB 1:     0MB
[   19.333141] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   19.339225] EDAC amd64: MC: 4:     0MB 5:     0MB
[   19.344247] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.348948] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00005050
[   19.348949] EDAC MC: DCT1 chip selects:
[   19.348954] EDAC amd64: MC: 0:     0MB 1:     0MB
[   19.353656] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   19.358365] EDAC amd64: MC: 4:     0MB 5:     0MB
[   19.363086] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.367799] EDAC amd64: using x8 syndromes.
[   19.371996] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00080100
[   19.371998] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   19.372003] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   19.372005] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   19.372007] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   19.372009] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
[   19.372011] EDAC amd64: MCT channel count: 2
[   19.376292] EDAC DEBUG: edac_mc_alloc: allocating 1904 bytes for mci data (16 ranks, 16 csrows/channels)
[   19.376323] EDAC DEBUG: init_csrows: node 0, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
[   19.376325] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   19.376327] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 5
[   19.376329] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.376331] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 1, DBAM idx: 5
[   19.376333] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.376335] EDAC amd64: CS2: Registered DDR3 RAM
[   19.380967] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
[   19.380970] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
[   19.380971] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 5
[   19.380973] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.380975] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 1, DBAM idx: 5
[   19.380977] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.380978] EDAC amd64: CS3: Registered DDR3 RAM
[   19.385610] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
[   19.385612] EDAC DEBUG: init_csrows: MC node: 0, csrow: 6
[   19.385614] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 0, DBAM idx: 5
[   19.385615] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.385617] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 1, DBAM idx: 5
[   19.385619] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.385620] EDAC amd64: CS6: Registered DDR3 RAM
[   19.390240] EDAC DEBUG: init_csrows: Total csrow6 pages: 524288
[   19.390242] EDAC DEBUG: init_csrows: MC node: 0, csrow: 7
[   19.390244] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 0, DBAM idx: 5
[   19.390246] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.390248] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 1, DBAM idx: 5
[   19.390250] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.390254] EDAC amd64: CS7: Registered DDR3 RAM
[   19.394875] EDAC DEBUG: init_csrows: Total csrow7 pages: 524288
[   19.394877] EDAC DEBUG: edac_mc_add_mc: 
[   19.394882] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   19.394913] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   19.394946] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   19.394977] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   19.394979] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   19.395001] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   19.395003] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm6, located at csrow 3 channel 0 
[   19.395024] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank6
[   19.395025] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm7, located at csrow 3 channel 1 
[   19.395085] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank7
[   19.395088] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm12, located at csrow 6 channel 0 
[   19.395108] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank12
[   19.395110] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm13, located at csrow 6 channel 1 
[   19.395133] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank13
[   19.395135] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm14, located at csrow 7 channel 0 
[   19.395156] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank14
[   19.395157] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm15, located at csrow 7 channel 1 
[   19.395186] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank15
[   19.395190] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   19.395212] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   19.395234] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow6
[   19.395266] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow7
[   19.395385] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
[   19.402852] EDAC amd64: DRAM ECC enabled.
[   19.406879] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406882] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 7, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406884] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 8, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406887] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 9, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406889] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 10, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406891] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 11, MCG_CTL: 0x3f, NB MSR is enabled
[   19.406893] EDAC amd64: F10h detected (node 1).
[   19.411431] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:19.1
[   19.411432] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:19.2
[   19.411434] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:19.3
[   19.411436] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
[   19.411439] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000420000000
[   19.411442] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
[   19.411444] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode
[   19.411445] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
[   19.411447] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
[   19.411449] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
[   19.411453] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000021fffffff
[   19.411455] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   19.411458] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000220000000; limit: 0x000000041fffffff
[   19.411460] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
[   19.411466] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000000 reg: F2x40
[   19.411468] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000000 reg: F2x140
[   19.411470] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   19.411472] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000000 reg: F2x144
[   19.411474] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000001 reg: F2x48
[   19.411476] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000001 reg: F2x148
[   19.411479] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000101 reg: F2x4c
[   19.411481] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000101 reg: F2x14c
[   19.411483] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   19.411485] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
[   19.411487] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   19.411489] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
[   19.411491] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000201 reg: F2x58
[   19.411493] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000201 reg: F2x158
[   19.411495] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000301 reg: F2x5c
[   19.411497] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000301 reg: F2x15c
[   19.411499] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00000000 reg: F2x60
[   19.411501] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x00000000 reg: F2x160
[   19.411504] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   19.411506] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x00f83ce0 reg: F2x164
[   19.411508] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   19.411510] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
[   19.411512] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00f83ce0 reg: F2x6c
[   19.411514] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00f83ce0 reg: F2x16c
[   19.411559] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x0200df5f
[   19.411560] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   19.411562] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   19.411565] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00080100
[   19.411566] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   19.411568] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   19.411570] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   19.411572] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   19.411573] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   19.411576] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0000002, base: 0xe0000000, offset: 0x00000000
[   19.411577] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
[   19.411580] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00005050
[   19.411581] EDAC MC: DCT0 chip selects:
[   19.411583] EDAC amd64: MC: 0:     0MB 1:     0MB
[   19.416285] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   19.420987] EDAC amd64: MC: 4:     0MB 5:     0MB
[   19.425683] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.430386] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00005050
[   19.430387] EDAC MC: DCT1 chip selects:
[   19.430389] EDAC amd64: MC: 0:     0MB 1:     0MB
[   19.435089] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   19.439785] EDAC amd64: MC: 4:     0MB 5:     0MB
[   19.444485] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.449187] EDAC amd64: using x8 syndromes.
[   19.453367] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00080100
[   19.453369] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   19.453371] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   19.453373] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   19.453376] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   19.453381] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
[   19.453383] EDAC amd64: MCT channel count: 2
[   19.457647] EDAC DEBUG: edac_mc_alloc: allocating 1904 bytes for mci data (16 ranks, 16 csrows/channels)
[   19.457671] EDAC DEBUG: init_csrows: node 1, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
[   19.457677] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.457679] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 1, DBAM idx: 5
[   19.457680] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.457682] EDAC amd64: CS2: Registered DDR3 RAM
[   19.462297] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
[   19.462299] EDAC DEBUG: init_csrows: MC node: 1, csrow: 3
[   19.462301] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 5
[   19.462303] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.462306] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 1, DBAM idx: 5
[   19.462311] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.462312] EDAC amd64: CS3: Registered DDR3 RAM
[   19.466922] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
[   19.466925] EDAC DEBUG: init_csrows: MC node: 1, csrow: 6
[   19.466928] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 0, DBAM idx: 5
[   19.466932] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.466934] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 1, DBAM idx: 5
[   19.466936] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.466937] EDAC amd64: CS6: Registered DDR3 RAM
[   19.471548] EDAC DEBUG: init_csrows: Total csrow6 pages: 524288
[   19.471550] EDAC DEBUG: init_csrows: MC node: 1, csrow: 7
[   19.471552] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 0, DBAM idx: 5
[   19.471557] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.471559] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 1, DBAM idx: 5
[   19.471560] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   19.471562] EDAC amd64: CS7: Registered DDR3 RAM
[   19.476176] EDAC DEBUG: init_csrows: Total csrow7 pages: 524288
[   19.476178] EDAC DEBUG: edac_mc_add_mc: 
[   19.476182] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc1
[   19.476215] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc1
[   19.476243] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   19.476266] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   19.476268] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   19.476287] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   19.476288] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm6, located at csrow 3 channel 0 
[   19.476322] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank6
[   19.476324] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm7, located at csrow 3 channel 1 
[   19.476344] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank7
[   19.476346] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm12, located at csrow 6 channel 0 
[   19.476375] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank12
[   19.476377] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm13, located at csrow 6 channel 1 
[   19.476402] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank13
[   19.476404] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm14, located at csrow 7 channel 0 
[   19.476429] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank14
[   19.476431] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm15, located at csrow 7 channel 1 
[   19.476452] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank15
[   19.476455] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   19.476542] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   19.476566] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow6
[   19.476589] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow7
[   19.476645] EDAC MC1: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:19.2
[   19.484112] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   19.484117] EDAC DEBUG: edac_pci_add_device: 
[   19.484120] EDAC DEBUG: add_edac_pci_to_global_list: 
[   19.484121] EDAC DEBUG: find_edac_pci_by_dev: 
[   19.484124] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   19.484125] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   19.484138] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   19.484139] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   19.484144] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   19.484146] EDAC DEBUG: edac_pci_workq_setup: 
[   19.484150] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)


-- 

Cheers,
Mauro
