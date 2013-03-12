Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3CLN6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:58:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab3CLN6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:58:51 -0400
Date: Tue, 12 Mar 2013 10:58:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312105829.20bba129@redhat.com>
In-Reply-To: <20130312115632.GB5370@pd.tnic>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
	<20130311092848.652c0d46@redhat.com>
	<20130312085855.GB5455@pd.tnic>
	<20130312091630.GC5455@pd.tnic>
	<20130312083448.6f3ce5f9@redhat.com>
	<20130312115632.GB5370@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 12 Mar 2013 12:56:32 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Tue, Mar 12, 2013 at 08:34:48AM -0300, Mauro Carvalho Chehab wrote:
> > Looks ok on my eyes. I'll test it here on both systems, with both this
> > patch and the second one:
> > 
> > http://git.infradead.org/users/mchehab/edac.git/commitdiff/56ba4c93d909ef9dfab4f1101a8c3bf75bc4cdab
> > 
> > It should take some time to finish compilation.
> 
> No hurry, I'd need to finish testing them and if all is fine, will send
> them upstream next week, the latest.

Ok. Anyway, x86_64 compilation finished. Just re-did the tests on both
machines:

Here are the tests with the modified version of the patch applied, on the
machine equipped with quad-rank RAMs:

/sys/devices/system/edac/mc/mc0/size_mb:8192
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow3/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow6/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow7/size_mb:2048

/sys/devices/system/edac/mc/mc1/size_mb:8192
/sys/devices/system/edac/mc/mc1/csrow2/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow3/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow6/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow7/size_mb:2048

/sys/devices/system/edac/mc/mc0/rank4/size:1024
/sys/devices/system/edac/mc/mc0/rank5/size:1024
/sys/devices/system/edac/mc/mc0/rank6/size:1024
/sys/devices/system/edac/mc/mc0/rank7/size:1024
/sys/devices/system/edac/mc/mc0/rank12/size:1024
/sys/devices/system/edac/mc/mc0/rank13/size:1024
/sys/devices/system/edac/mc/mc0/rank14/size:1024
/sys/devices/system/edac/mc/mc0/rank15/size:1024
/sys/devices/system/edac/mc/mc1/rank4/size:1024
/sys/devices/system/edac/mc/mc1/rank5/size:1024
/sys/devices/system/edac/mc/mc1/rank6/size:1024
/sys/devices/system/edac/mc/mc1/rank7/size:1024
/sys/devices/system/edac/mc/mc1/rank12/size:1024
/sys/devices/system/edac/mc/mc1/rank13/size:1024
/sys/devices/system/edac/mc/mc1/rank14/size:1024
/sys/devices/system/edac/mc/mc1/rank15/size:1024

[    0.000000] Linux version 3.8.2-209.fc18.x86_64.debug (mockbuild@buildvm-04.phx2.fedoraproject.org) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP Tue Mar 12 11:37:54 UTC 2013

[   33.321105] EDAC MC: Ver: 3.0.0
[   33.325269] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   33.630374] AMD64 EDAC driver v3.4.0
[   33.634117] EDAC amd64: DRAM ECC enabled.
[   33.638170] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638174] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 2, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638177] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 3, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638180] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 4, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638183] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 5, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638186] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 6, MCG_CTL: 0x3f, NB MSR is enabled
[   33.638203] EDAC amd64: F10h detected (node 0).
[   33.642795] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   33.642797] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   33.642800] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   33.642804] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
[   33.642807] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000420000000
[   33.642813] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
[   33.642816] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode
[   33.642818] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
[   33.642821] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
[   33.642824] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
[   33.642835] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000021fffffff
[   33.642839] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   33.642845] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000220000000; limit: 0x000000041fffffff
[   33.642849] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
[   33.642860] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000000 reg: F2x40
[   33.642863] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000000 reg: F2x140
[   33.642867] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   33.642871] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000000 reg: F2x144
[   33.642874] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000001 reg: F2x48
[   33.642877] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000001 reg: F2x148
[   33.642880] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000101 reg: F2x4c
[   33.642883] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000101 reg: F2x14c
[   33.642887] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   33.642890] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
[   33.642893] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   33.642896] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
[   33.642898] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000201 reg: F2x58
[   33.642901] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000201 reg: F2x158
[   33.642904] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000301 reg: F2x5c
[   33.642907] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000301 reg: F2x15c
[   33.642911] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00000000 reg: F2x60
[   33.642914] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x00000000 reg: F2x160
[   33.642917] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   33.642919] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x00f83ce0 reg: F2x164
[   33.642922] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   33.642925] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
[   33.642928] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00f83ce0 reg: F2x6c
[   33.642931] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00f83ce0 reg: F2x16c
[   33.642939] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x0200df5f
[   33.642941] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   33.642943] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   33.642946] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00080100
[   33.642949] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   33.642951] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   33.642953] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   33.642956] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   33.642958] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   33.642961] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0002003, base: 0xe0000000, offset: 0x20000000
[   33.642963] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
[   33.642966] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00005050
[   33.642968] EDAC MC: DCT0 chip selects:
[   33.642971] EDAC amd64: MC: 0:     0MB 1:     0MB
[   33.647688] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   33.652393] EDAC amd64: MC: 4:     0MB 5:     0MB
[   33.657105] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   33.661806] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00005050
[   33.661808] EDAC MC: DCT1 chip selects:
[   33.661813] EDAC amd64: MC: 0:     0MB 1:     0MB
[   33.666635] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   33.671346] EDAC amd64: MC: 4:     0MB 5:     0MB
[   33.676062] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   33.680803] EDAC amd64: using x8 syndromes.
[   33.685008] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00080100
[   33.685011] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   33.685013] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   33.685016] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   33.685018] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   33.685021] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
[   33.685023] EDAC amd64: MCT channel count: 2
[   33.819675] EDAC DEBUG: edac_mc_alloc: allocating 2112 bytes for mci data (16 ranks, 16 csrows/channels)
[   33.820376] EDAC DEBUG: init_csrows: node 0, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
[   33.820379] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   33.820382] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 5
[   33.820385] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.820388] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 1, DBAM idx: 5
[   33.820390] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.820392] EDAC amd64: CS2: Registered DDR3 RAM
[   33.825143] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
[   33.825144] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
[   33.825146] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 5
[   33.825147] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825148] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 1, DBAM idx: 5
[   33.825149] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825150] EDAC amd64: CS3: Registered DDR3 RAM
[   33.825151] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
[   33.825152] EDAC DEBUG: init_csrows: MC node: 0, csrow: 6
[   33.825153] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 0, DBAM idx: 5
[   33.825154] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825155] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 1, DBAM idx: 5
[   33.825156] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825157] EDAC amd64: CS6: Registered DDR3 RAM
[   33.825158] EDAC DEBUG: init_csrows: Total csrow6 pages: 524288
[   33.825159] EDAC DEBUG: init_csrows: MC node: 0, csrow: 7
[   33.825160] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 0, DBAM idx: 5
[   33.825161] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825163] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 1, DBAM idx: 5
[   33.825164] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.825165] EDAC amd64: CS7: Registered DDR3 RAM
[   33.825166] EDAC DEBUG: init_csrows: Total csrow7 pages: 524288
[   33.825168] EDAC DEBUG: edac_mc_add_mc: 
[   33.825184] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   33.825718] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   33.826335] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   33.826864] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   33.826867] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   33.827416] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   33.827420] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm6, located at csrow 3 channel 0 
[   33.827940] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank6
[   33.827943] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm7, located at csrow 3 channel 1 
[   33.828503] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank7
[   33.828506] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm12, located at csrow 6 channel 0 
[   33.829529] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank12
[   33.829532] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm13, located at csrow 6 channel 1 
[   33.830752] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank13
[   33.830755] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm14, located at csrow 7 channel 0 
[   33.831915] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank14
[   33.831918] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm15, located at csrow 7 channel 1 
[   33.832687] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank15
[   33.832725] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   33.833782] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   33.834522] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow6
[   33.835333] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow7
[   33.836763] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
[   33.837000] EDAC amd64: DRAM ECC enabled.
[   33.837037] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837039] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 7, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837041] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 8, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837042] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 9, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837044] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 10, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837046] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 11, MCG_CTL: 0x3f, NB MSR is enabled
[   33.837061] EDAC amd64: F10h detected (node 1).
[   33.837084] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:19.1
[   33.837085] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:19.2
[   33.837086] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:19.3
[   33.837088] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
[   33.837089] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000420000000
[   33.837094] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
[   33.837095] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode
[   33.837097] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
[   33.837099] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
[   33.837100] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
[   33.837107] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000021fffffff
[   33.837109] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   33.837112] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000220000000; limit: 0x000000041fffffff
[   33.837114] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
[   33.837123] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000000 reg: F2x40
[   33.837125] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000000 reg: F2x140
[   33.837127] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   33.837128] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000000 reg: F2x144
[   33.837130] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000001 reg: F2x48
[   33.837131] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000001 reg: F2x148
[   33.837133] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000101 reg: F2x4c
[   33.837135] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000101 reg: F2x14c
[   33.837137] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   33.837139] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
[   33.837141] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   33.837143] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
[   33.837144] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000201 reg: F2x58
[   33.837146] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000201 reg: F2x158
[   33.837148] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000301 reg: F2x5c
[   33.837149] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000301 reg: F2x15c
[   33.837152] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00000000 reg: F2x60
[   33.837153] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x00000000 reg: F2x160
[   33.837155] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   33.837157] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x00f83ce0 reg: F2x164
[   33.837159] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   33.837160] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
[   33.837162] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00f83ce0 reg: F2x6c
[   33.837164] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00f83ce0 reg: F2x16c
[   33.837173] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x0200df5f
[   33.837175] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   33.837176] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   33.837177] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00080100
[   33.837179] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   33.837179] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   33.837180] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   33.837182] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   33.837183] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   33.837184] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0000002, base: 0xe0000000, offset: 0x00000000
[   33.837185] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
[   33.837187] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00005050
[   33.837187] EDAC MC: DCT0 chip selects:
[   33.837189] EDAC amd64: MC: 0:     0MB 1:     0MB
[   33.837190] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   33.837191] EDAC amd64: MC: 4:     0MB 5:     0MB
[   33.837192] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   33.837194] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00005050
[   33.837195] EDAC MC: DCT1 chip selects:
[   33.837196] EDAC amd64: MC: 0:     0MB 1:     0MB
[   33.837197] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   33.837198] EDAC amd64: MC: 4:     0MB 5:     0MB
[   33.837199] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   33.837200] EDAC amd64: using x8 syndromes.
[   33.837201] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00080100
[   33.837202] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   33.837203] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   33.837204] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   33.837205] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   33.837207] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
[   33.837208] EDAC amd64: MCT channel count: 2
[   33.837211] EDAC DEBUG: edac_mc_alloc: allocating 2112 bytes for mci data (16 ranks, 16 csrows/channels)
[   33.837750] EDAC DEBUG: init_csrows: node 1, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
[   33.837752] EDAC DEBUG: init_csrows: MC node: 1, csrow: 2
[   33.837753] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 5
[   33.837754] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837755] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 1, DBAM idx: 5
[   33.837756] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837757] EDAC amd64: CS2: Registered DDR3 RAM
[   33.837758] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
[   33.837759] EDAC DEBUG: init_csrows: MC node: 1, csrow: 3
[   33.837760] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 5
[   33.837761] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837762] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 1, DBAM idx: 5
[   33.837763] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837763] EDAC amd64: CS3: Registered DDR3 RAM
[   33.837764] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
[   33.837765] EDAC DEBUG: init_csrows: MC node: 1, csrow: 6
[   33.837766] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 0, DBAM idx: 5
[   33.837767] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837768] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 1, DBAM idx: 5
[   33.837769] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837769] EDAC amd64: CS6: Registered DDR3 RAM
[   33.837770] EDAC DEBUG: init_csrows: Total csrow6 pages: 524288
[   33.837771] EDAC DEBUG: init_csrows: MC node: 1, csrow: 7
[   33.837772] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 0, DBAM idx: 5
[   33.837773] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837774] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 1, DBAM idx: 5
[   33.837775] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   33.837776] EDAC amd64: CS7: Registered DDR3 RAM
[   33.837777] EDAC DEBUG: init_csrows: Total csrow7 pages: 524288
[   33.837778] EDAC DEBUG: edac_mc_add_mc: 
[   33.837791] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc1
[   33.838160] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc1
[   33.838777] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   33.839304] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   33.839308] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm5, located at csrow 2 channel 1 
[   33.839925] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank5
[   33.839929] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm6, located at csrow 3 channel 0 
[   33.840422] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank6
[   33.840424] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm7, located at csrow 3 channel 1 
[   33.841280] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank7
[   33.841285] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm12, located at csrow 6 channel 0 
[   33.842280] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank12
[   33.842284] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm13, located at csrow 6 channel 1 
[   33.843412] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank13
[   33.843416] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm14, located at csrow 7 channel 0 
[   33.844309] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank14
[   33.844312] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm15, located at csrow 7 channel 1 
[   33.845036] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank15
[   33.845080] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   33.846041] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   33.846972] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow6
[   33.847806] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow7
[   33.848839] EDAC MC1: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:19.2
[   33.849338] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   33.849353] EDAC DEBUG: edac_pci_add_device: 
[   33.849355] EDAC DEBUG: add_edac_pci_to_global_list: 
[   33.849356] EDAC DEBUG: find_edac_pci_by_dev: 
[   33.849358] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   33.849359] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   33.849677] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   33.849678] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   33.849750] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   33.849772] EDAC DEBUG: edac_pci_workq_setup: 
[   33.849800] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)

Those are the results at the K8 Rev. F:

/sys/devices/system/edac/mc/mc0/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow0/size_mb:1024
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:1024

/sys/devices/system/edac/mc/mc0/rank0/size:1024
/sys/devices/system/edac/mc/mc0/rank4/size:1024

[    0.000000] Linux version 3.8.2-209.fc18.x86_64.debug (mockbuild@buildvm-04.phx2.fedoraproject.org) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP Tue Mar 12 11:37:54 UTC 2013
[   25.841294] EDAC MC: Ver: 3.0.0
[   25.852923] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   26.262320] AMD64 EDAC driver v3.4.0
[   26.268595] EDAC amd64: DRAM ECC enabled.
[   26.272642] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   26.272649] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   26.272678] EDAC amd64: K8 revF or later detected (node 0).
[   26.278298] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   26.278304] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   26.278308] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   26.278313] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x0000000080000000
[   26.278317] EDAC DEBUG: read_mc_regs:   TOP_MEM2 disabled
[   26.278327] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000007fffffff
[   26.278333] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   26.278356] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   26.278362] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
[   26.278368] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000101 reg: F2x48
[   26.278374] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000000 reg: F2x4c
[   26.278380] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   26.278386] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   26.278392] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   26.278399] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   26.278406] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00783ee0 reg: F2x60
[   26.278412] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00783ee0 reg: F2x64
[   26.278418] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   26.278424] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   26.278435] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   26.278439] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   26.278444] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   26.278449] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090c10
[   26.278454] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   26.278458] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   26.278463] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   26.278467] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
[   26.278473] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0x00000000, base: 0x00000000, offset: 0x00000000
[   26.278477] EDAC DEBUG: dump_misc_regs:   DramHoleValid: no
[   26.278483] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   26.278487] EDAC MC: DCT0 chip selects:
[   26.278492] EDAC amd64: MC: 0:  1024MB 1:     0MB
[   26.283203] EDAC amd64: MC: 2:  1024MB 3:     0MB
[   26.287907] EDAC amd64: MC: 4:     0MB 5:     0MB
[   26.292610] EDAC amd64: MC: 6:     0MB 7:     0MB
[   26.297328] EDAC DEBUG: edac_mc_alloc: allocating 2112 bytes for mci data (16 ranks, 16 csrows/channels)
[   26.298310] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   26.298316] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   26.298321] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, DBAM idx: 2
[   26.298326] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.298331] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   26.303187] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   26.303192] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   26.303197] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 2
[   26.303202] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   26.303207] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   26.307834] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   26.307841] EDAC DEBUG: edac_mc_add_mc: 
[   26.307876] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   26.311539] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   26.312437] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   26.313343] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   26.313349] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm4, located at csrow 2 channel 0 
[   26.314190] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank4
[   26.314239] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   26.315196] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   26.317185] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   26.325564] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   26.325589] EDAC DEBUG: edac_pci_add_device: 
[   26.325594] EDAC DEBUG: add_edac_pci_to_global_list: 
[   26.325598] EDAC DEBUG: find_edac_pci_by_dev: 
[   26.325604] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   26.325608] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   26.325783] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   26.325788] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   26.325891] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   26.325928] EDAC DEBUG: edac_pci_workq_setup: 
[   26.325943] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)

Fedora's Kernel build is at:
	https://koji.fedoraproject.org/koji/taskinfo?taskID=5111749

Regards,
Mauro
