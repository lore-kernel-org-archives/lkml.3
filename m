Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaJMKSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:18:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:26282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbaJMKSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,709,1406617200"; 
   d="scan'208";a="613554421"
Date: Mon, 13 Oct 2014 13:18:50 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [drm/i915] 5ba60fc3d71:
 dmesg.WARNING:at_drivers/gpu/drm/i915/intel_pm.c:sandybridge_pcode_write_i915()
Message-ID: <20141013101850.GA4284@intel.com>
References: <20141011052935.GE21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141011052935.GE21803@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 01:29:35PM +0800, Fengguang Wu wrote:
> FYI, we noticed the below changes on
> 
> git://gitorious.org/vsyrjala/linux cdclk_3
> commit 5ba60fc3d719988a404d35a3e46f109bea643fef ("drm/i915: BDW cdclk change support")
> 
> 
<snip>
> [   13.959092] WARNING: CPU: 0 PID: 75 at drivers/gpu/drm/i915/intel_pm.c:6231 sandybridge_pcode_write+0x171/0x190 [i915]()
> [   13.959112] Modules linked in: snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_timer snd winbond_cir drm soundcore ahci libahci rc_core pcspkr i2c_i801 libata parport_pc parport i2c_hid sdhci_acpi sdhci mmc_core video dw_dmac dw_dmac_core acpi_pad
> [   13.959115] CPU: 0 PID: 75 Comm: kworker/u16:1 Not tainted 3.17.0-rc7-g5ba60fc #1
> [   13.959116] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
> [   13.959122] Workqueue: events_unbound async_run_entry_fn
> [   13.959126]  0000000000000009 ffff880092cbb850 ffffffff818570a6 0000000000000000
> [   13.959129]  ffff880092cbb888 ffffffff8106ef1d ffff88014d380000 0000000000000000
> [   13.959131]  0000000000000018 ffff88014dc862f0 ffff88014d380000 ffff880092cbb898
> [   13.959132] Call Trace:
> [   13.959137]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
> [   13.959142]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
> [   13.959145]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
> [   13.959173]  [<ffffffffa0213a51>] sandybridge_pcode_write+0x171/0x190 [i915]
> [   13.959212]  [<ffffffffa0267926>] haswell_modeset_global_resources+0x196/0x4a0 [i915]

Thanks for the report. Seems I forgot to grab the relevant lock here.
Fixed patches pushed to cdclk_4 branch.

-- 
Ville Syrjälä
Intel OTC
