Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab3CIPqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 10:46:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49860 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab3CIPqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 10:46:45 -0500
Date: Sat, 9 Mar 2013 16:46:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130309154635.GA18316@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121211140108.GC4303@liondog.tnic>
 <20130307095703.03d040ee@redhat.com>
 <20130307130635.GD5239@pd.tnic>
 <20130307110213.7a5a9978@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130307110213.7a5a9978@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:02:13AM -0300, Mauro Carvalho Chehab wrote:
> Sure. See below:
> 
> [   19.062902] EDAC MC: Ver: 3.0.0
> [   19.088757] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [   19.284745] AMD64 EDAC driver v3.4.0
> [   19.299082] EDAC amd64: DRAM ECC enabled.
> [   19.315960] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x3f, NB MSR is enabled

								^^^^^^^
Whoops, where did core 1 go? Strange.

> [   19.321115] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 2, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.321118] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 3, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.321120] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 4, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.321123] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 5, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.321125] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 6, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.321140] EDAC amd64: F10h detected (node 0).
> [   19.327072] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
> [   19.327074] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
> [   19.327076] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
> [   19.327078] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
> [   19.327081] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000420000000

Looks about right - 16G.

> [   19.327087] EDAC DEBUG: read_dram_ctl_register: F2x110 (DCTSelLow): 0x000005e4, High range addrs at: 0x0
> [   19.327089] EDAC DEBUG: read_dram_ctl_register:   DCTs operate in unganged mode
> [   19.327091] EDAC DEBUG: read_dram_ctl_register:   Address range split per DCT: no
> [   19.327093] EDAC DEBUG: read_dram_ctl_register:   data interleave for ECC: enabled, DRAM cleared since last warm reset: yes
> [   19.327095] EDAC DEBUG: read_dram_ctl_register:   channel interleave: enabled, interleave bits selector: 0x3
> [   19.327099] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x000000021fffffff
> [   19.327101] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
> [   19.327104] EDAC DEBUG: read_mc_regs:   DRAM range[1], base: 0x0000000220000000; limit: 0x000000041fffffff
> [   19.327107] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=1
> [   19.327114] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000000 reg: F2x40
> [   19.327117] EDAC DEBUG: read_dct_base_mask:   DCSB1[0]=0x00000000 reg: F2x140
> [   19.327119] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000000 reg: F2x44
> [   19.327121] EDAC DEBUG: read_dct_base_mask:   DCSB1[1]=0x00000000 reg: F2x144
> [   19.327123] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000001 reg: F2x48
> [   19.327125] EDAC DEBUG: read_dct_base_mask:   DCSB1[2]=0x00000001 reg: F2x148
> [   19.327129] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000101 reg: F2x4c
> [   19.327131] EDAC DEBUG: read_dct_base_mask:   DCSB1[3]=0x00000101 reg: F2x14c
> [   19.327134] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
> [   19.327136] EDAC DEBUG: read_dct_base_mask:   DCSB1[4]=0x00000000 reg: F2x150
> [   19.327138] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
> [   19.327140] EDAC DEBUG: read_dct_base_mask:   DCSB1[5]=0x00000000 reg: F2x154
> [   19.327142] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000201 reg: F2x58
> [   19.327144] EDAC DEBUG: read_dct_base_mask:   DCSB1[6]=0x00000201 reg: F2x158
> [   19.327146] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000301 reg: F2x5c
> [   19.327148] EDAC DEBUG: read_dct_base_mask:   DCSB1[7]=0x00000301 reg: F2x15c
> [   19.327150] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00000000 reg: F2x60
> [   19.327152] EDAC DEBUG: read_dct_base_mask:     DCSM1[0]=0x00000000 reg: F2x160
> [   19.327155] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
> [   19.327157] EDAC DEBUG: read_dct_base_mask:     DCSM1[1]=0x00f83ce0 reg: F2x164
> [   19.327159] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
> [   19.327161] EDAC DEBUG: read_dct_base_mask:     DCSM1[2]=0x00000000 reg: F2x168
> [   19.327163] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00f83ce0 reg: F2x6c
> [   19.327165] EDAC DEBUG: read_dct_base_mask:     DCSM1[3]=0x00f83ce0 reg: F2x16c
> [   19.327169] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x0200df5f
> [   19.327170] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
> [   19.327172] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
> [   19.327175] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00080100
> [   19.327179] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
> [   19.327181] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
> [   19.327183] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
> [   19.327185] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
> [   19.327187] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x00000000
> [   19.327189] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0002003, base: 0xe0000000, offset: 0x20000000
> [   19.327190] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
> [   19.327193] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00005050
> [   19.327195] EDAC MC: DCT0 chip selects:
> [   19.327196] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   19.333141] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   19.339225] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   19.344247] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> [   19.348948] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00005050
> [   19.348949] EDAC MC: DCT1 chip selects:
> [   19.348954] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   19.353656] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   19.358365] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   19.363086] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> [   19.367799] EDAC amd64: using x8 syndromes.
> [   19.371996] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00080100
> [   19.371998] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
> [   19.372003] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
> [   19.372005] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
> [   19.372007] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
> [   19.372009] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
> [   19.372011] EDAC amd64: MCT channel count: 2
> [   19.376292] EDAC DEBUG: edac_mc_alloc: allocating 1904 bytes for mci data (16 ranks, 16 csrows/channels)
> [   19.376323] EDAC DEBUG: init_csrows: node 0, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
> [   19.376325] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
> [   19.376327] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 5
> [   19.376329] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.376331] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 1, DBAM idx: 5
> [   19.376333] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.376335] EDAC amd64: CS2: Registered DDR3 RAM
> [   19.380967] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
> [   19.380970] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
> [   19.380971] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 5
> [   19.380973] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.380975] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 1, DBAM idx: 5
> [   19.380977] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.380978] EDAC amd64: CS3: Registered DDR3 RAM
> [   19.385610] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
> [   19.385612] EDAC DEBUG: init_csrows: MC node: 0, csrow: 6
> [   19.385614] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 0, DBAM idx: 5
> [   19.385615] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.385617] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 6, channel: 1, DBAM idx: 5
> [   19.385619] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.385620] EDAC amd64: CS6: Registered DDR3 RAM
> [   19.390240] EDAC DEBUG: init_csrows: Total csrow6 pages: 524288
> [   19.390242] EDAC DEBUG: init_csrows: MC node: 0, csrow: 7
> [   19.390244] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 0, DBAM idx: 5
> [   19.390246] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.390248] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 7, channel: 1, DBAM idx: 5
> [   19.390250] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   19.390254] EDAC amd64: CS7: Registered DDR3 RAM
> [   19.394875] EDAC DEBUG: init_csrows: Total csrow7 pages: 524288

[ … ]

> [   19.395385] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
> [   19.402852] EDAC amd64: DRAM ECC enabled.
> [   19.406879] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x3f, NB MSR is enabled

here's core 1, WTF? on the second node? Great.

> [   19.406882] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 7, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.406884] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 8, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.406887] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 9, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.406889] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 10, MCG_CTL: 0x3f, NB MSR is enabled
> [   19.406891] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 11, MCG_CTL: 0x3f, NB MSR is enabled

[ … ]

On Thu, Mar 07, 2013 at 09:57:03AM -0300, Mauro Carvalho Chehab wrote:
> This is what the csrows nodes show:
>
> /sys/devices/system/edac/mc/mc0/csrow2/size_mb:2048
> /sys/devices/system/edac/mc/mc0/csrow3/size_mb:2048
> /sys/devices/system/edac/mc/mc0/csrow6/size_mb:2048
> /sys/devices/system/edac/mc/mc0/csrow7/size_mb:2048
> /sys/devices/system/edac/mc/mc1/csrow2/size_mb:2048
> /sys/devices/system/edac/mc/mc1/csrow3/size_mb:2048
> /sys/devices/system/edac/mc/mc1/csrow6/size_mb:2048
> /sys/devices/system/edac/mc/mc1/csrow7/size_mb:2048

This is correct.

Each chip select has 1024M per DCT but since we have 2 DCTs per node,
that's 1024M * 2 = 2G per chip select of a MC.

> Total size is 16Gb, but the number of ranks are wrong.

Well, chip select != rank, remember?

> This is what's reported by the new API:
> 
> /sys/devices/system/edac/mc/mc0/rank12/size:2048
> /sys/devices/system/edac/mc/mc0/rank13/size:2048
> /sys/devices/system/edac/mc/mc0/rank14/size:2048
> /sys/devices/system/edac/mc/mc0/rank15/size:2048
> /sys/devices/system/edac/mc/mc0/rank4/size:2048
> /sys/devices/system/edac/mc/mc0/rank5/size:2048
> /sys/devices/system/edac/mc/mc0/rank6/size:2048
> /sys/devices/system/edac/mc/mc0/rank7/size:2048
> /sys/devices/system/edac/mc/mc1/rank12/size:2048
> /sys/devices/system/edac/mc/mc1/rank13/size:2048
> /sys/devices/system/edac/mc/mc1/rank14/size:2048
> /sys/devices/system/edac/mc/mc1/rank15/size:2048
> /sys/devices/system/edac/mc/mc1/rank4/size:2048
> /sys/devices/system/edac/mc/mc1/rank5/size:2048
> /sys/devices/system/edac/mc/mc1/rank6/size:2048
> /sys/devices/system/edac/mc/mc1/rank7/size:2048
> 
> Here, the number of ranks are ok, but the size is wrong.
> 
> This is what the edac debug logs say:
> 
> [   18.829184] EDAC amd64: F10h detected (node 0).
> [   18.829206] EDAC MC: DCT0 chip selects:
> [   18.829207] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   18.829219] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   18.829220] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   18.829221] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> [   18.829222] EDAC MC: DCT1 chip selects:
> [   18.829223] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   18.829223] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   18.829224] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   18.829225] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> 
> [   18.923914] EDAC amd64: F10h detected (node 1).
> [   18.956025] EDAC MC: DCT0 chip selects:
> [   18.956028] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   18.962055] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   18.968167] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   18.974252] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> [   18.980333] EDAC MC: DCT1 chip selects:
> [   18.980335] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   18.986415] EDAC amd64: MC: 2:  1024MB 3:  1024MB
> [   18.991454] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   18.996155] EDAC amd64: MC: 6:  1024MB 7:  1024MB
> [   19.000854] EDAC amd64: using x8 syndromes.
> 
> Here, everything is fine.

So, actually to satisfy the new api, you'll probably need to stick down
this information above, i.e. the chip selects *per* DCT which equals
also the ranks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
