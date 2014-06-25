Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbaFYS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:26:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:36094 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671AbaFYS0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,547,1400050800"; 
   d="scan'208";a="560905895"
Date: Wed, 25 Jun 2014 21:26:09 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Regression in i915 driver in 3.16-rc2
Message-ID: <20140625182609.GY27580@intel.com>
References: <20140108161713.GT4770@phenom.ffwll.local>
 <Pine.LNX.4.44L0.1406251358001.871-300000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1406251358001.871-300000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 02:06:55PM -0400, Alan Stern wrote:
> Daniel:
> 
> I encountered a new problem in the i915 driver the first time I booted 
> a 3.16-rc kernel on this computer.  When it switched over to the frame 
> buffer driver, the screen went blank and stayed that way.
> 
> 3.15 works okay.
> 
> Attached are log extracts from 3.15 and 3.16 (both with drm.debug=0xe
> in the boot command line).  The timestamps have been stripped out for
> easy diff comparison.  These are the result of
> 
> 	dmesg | egrep 'drm|i915|frame'
> 
> with a couple of irrelevant lines removed.  I can send the complete 
> logs if you need them.
> 
> Alan Stern

> Kernel command line: BOOT_IMAGE=/boot/test-3.x root=/dev/hda8 ro console=ttyS0,115200 console=tty0 earlyprintk=serial,ttyS0,115200 no_console_suspend drm.debug=0xe vconsole.keymap=us vconsole.font=latarcyrheb-sun16 LANG=en_US.UTF-8 usbcore.dyndbg=+p ehci_hcd.dyndbg=+p
> [drm] Initialized drm 1.1.0 20060810
> [drm:i915_dump_device_info] i915 device info: gen=2, pciid=0x2572 flags=has_overlay,overlay_needs_physical,
> [drm:intel_detect_pch] No PCH found.
> [drm] Memory usable by graphics device = 128M
> [drm:i915_gem_gtt_init] GMADR size = 128M
> [drm:i915_gem_gtt_init] GTT stolen size = 8M
> [drm:i915_gem_gtt_init] ppgtt mode: 0
> [drm:intel_opregion_setup] graphic opregion physical addr: 0x0
> [drm:intel_opregion_setup] ACPI OpRegion not supported!
> [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [drm] Driver supports precise vblank timestamp query.
> [drm:init_vbt_defaults] Set default to SSC at 66667 kHz
> [drm:parse_general_features] BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 48000 display_clock_mode 0 fdi_rx_polarity_inverted 0
                                                                     ^^^^^^^^^^^^^^^^^

This should get your display back:
http://patchwork.freedesktop.org/patch/28508/

-- 
Ville Syrjälä
Intel OTC
