Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaJKOMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:12:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:38966 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaJKOML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,698,1406617200"; 
   d="scan'208";a="587259819"
Date: Sat, 11 Oct 2014 17:11:51 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [drm/i915] WARNING: CPU: 2 PID: 260 at
 drivers/gpu/drm/i915/intel_display.c:1151 assert_plane+0x83/0x90 [i915]()
Message-ID: <20141011141151.GM32511@intel.com>
References: <20141011051743.GC21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141011051743.GC21803@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 01:17:43PM +0800, Fengguang Wu wrote:
> Hi Ville,
> 
> FYI, we noticed the below changes on
> 
> commit a5c4d7bc187bd13bc11ac06bb4ea3a0d4001aa4d ("drm/i915: Disable/enable planes as the first/last thing during modeset on ILK+")
> 
> 
> +-------------------------+------------+------------+
> |                         | be6a6f8ec7 | a5c4d7bc18 |
> +-------------------------+------------+------------+
> | boot_successes          | 10         | 0          |
> | boot_failures           | 0          | 10         |
> | BUG:kernel_test_crashed | 0          | 10         |
> +-------------------------+------------+------------+
> 
> 
> [   11.123997] ata1.00: configured for UDMA/100
> [   11.124256] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 0084 PQ: 0 ANSI: 5
> [   11.168246] ------------[ cut here ]------------
> [   11.168298] WARNING: CPU: 2 PID: 260 at drivers/gpu/drm/i915/intel_display.c:1151 assert_plane+0x83/0x90 [i915]()
> [   11.168300] plane A assertion failure (expected on, current off)
> [   11.168326] Modules linked in: mxm_wmi thinkpad_acpi parport_pc uvcvideo snd_hda_intel(+) videobuf2_vmalloc parport videobuf2_memops pcspkr snd_hda_controller rfkill i915(+) sdhci_pci videobuf2_core firewire_ohci snd_hda_codec ahci intel_ips libahci video videodev i2c_i801 snd_hwdep sdhci libata drm_kms_helper wmi firewire_core snd_pcm crc_itu_t mmc_core snd_timer drm snd soundcore acpi_cpufreq
> [   11.168330] CPU: 2 PID: 260 Comm: modprobe Not tainted 3.15.0-rc3-00206-g885ac04 #1
> [   11.168332] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
> [   11.168336]  0000000000000009 ffff880076fa1308 ffffffff8183c279 ffff880076fa1350
> [   11.168338]  ffff880076fa1340 ffffffff81069c7d 0000000000000000 0000000000000001
> [   11.168341]  00000000000c200c 00000000000f0018 0000000000060100 ffff880076fa13a0
> [   11.168342] Call Trace:
> [   11.168351]  [<ffffffff8183c279>] dump_stack+0x4d/0x66
> [   11.168357]  [<ffffffff81069c7d>] warn_slowpath_common+0x7d/0xa0
> [   11.168360]  [<ffffffff81069cec>] warn_slowpath_fmt+0x4c/0x50
> [   11.168399]  [<ffffffffa0207e47>] ? gen5_read32+0x57/0xd0 [i915]
> [   11.168438]  [<ffffffffa020e383>] assert_plane+0x83/0x90 [i915]
> [   11.168478]  [<ffffffffa0216bfe>] ironlake_fdi_link_train+0x6e/0x3d0 [i915]

Yeah I forgot about that bogus assert when doing that patch. But I did
catch it later:

commit 1c8562f66567807236c225d1518b0f034396f38a
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Fri Apr 25 22:12:07 2014 +0300

    drm/i915: Fix assert_plane warning during FDI link train

-- 
Ville Syrjälä
Intel OTC
