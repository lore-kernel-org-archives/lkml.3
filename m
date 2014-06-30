Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaF3Kws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:52:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:29545 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbaF3Kwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,574,1400050800"; 
   d="scan'208";a="451560279"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Regression in i915 driver in 3.16-rc2
In-Reply-To: <Pine.LNX.4.44L0.1406251450110.822-100000@iolanthe.rowland.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <Pine.LNX.4.44L0.1406251450110.822-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.18+25~gfdc3e52 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 30 Jun 2014 13:52:35 +0300
Message-ID: <8738emis98.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 25 Jun 2014, Ville [iso-8859-1] Syrjl wrote:
>
>> On Wed, Jun 25, 2014 at 02:06:55PM -0400, Alan Stern wrote:
>> > Daniel:
>> > 
>> > I encountered a new problem in the i915 driver the first time I booted 
>> > a 3.16-rc kernel on this computer.  When it switched over to the frame 
>> > buffer driver, the screen went blank and stayed that way.
>> > 
>> > 3.15 works okay.
>> > 
>> > Attached are log extracts from 3.15 and 3.16 (both with drm.debug=0xe
>> > in the boot command line).  The timestamps have been stripped out for
>> > easy diff comparison.  These are the result of
>> > 
>> > 	dmesg | egrep 'drm|i915|frame'
>> > 
>> > with a couple of irrelevant lines removed.  I can send the complete 
>> > logs if you need them.
>> > 
>> > Alan Stern
>> 
>> > Kernel command line: BOOT_IMAGE=/boot/test-3.x root=/dev/hda8 ro console=ttyS0,115200 console=tty0 earlyprintk=serial,ttyS0,115200 no_console_suspend drm.debug=0xe vconsole.keymap=us vconsole.font=latarcyrheb-sun16 LANG=en_US.UTF-8 usbcore.dyndbg=+p ehci_hcd.dyndbg=+p
>> > [drm] Initialized drm 1.1.0 20060810
>> > [drm:i915_dump_device_info] i915 device info: gen=2, pciid=0x2572 flags=has_overlay,overlay_needs_physical,
>> > [drm:intel_detect_pch] No PCH found.
>> > [drm] Memory usable by graphics device = 128M
>> > [drm:i915_gem_gtt_init] GMADR size = 128M
>> > [drm:i915_gem_gtt_init] GTT stolen size = 8M
>> > [drm:i915_gem_gtt_init] ppgtt mode: 0
>> > [drm:intel_opregion_setup] graphic opregion physical addr: 0x0
>> > [drm:intel_opregion_setup] ACPI OpRegion not supported!
>> > [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
>> > [drm] Driver supports precise vblank timestamp query.
>> > [drm:init_vbt_defaults] Set default to SSC at 66667 kHz
>> > [drm:parse_general_features] BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 48000 display_clock_mode 0 fdi_rx_polarity_inverted 0
>>                                                                      ^^^^^^^^^^^^^^^^^
>> 
>> This should get your display back:
>> http://patchwork.freedesktop.org/patch/28508/
>
> It did indeed.  Thank you very much.

Fix pushed to drm-intel-fixes; expect to land in v3.16-rc4 or v3.16-rc5
at the latest.

Thanks for the report and testing.

BR,
Jani.


>
> Alan Stern
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Technology Center
