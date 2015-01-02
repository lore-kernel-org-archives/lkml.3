Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbbABHla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 02:41:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:28070 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbbABHl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 02:41:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,683,1413270000"; 
   d="scan'208";a="655936873"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:11375 [i915] in 3.19-rc2
In-Reply-To: <20150101142215.GA2570@yulia-desktop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20150101142215.GA2570@yulia-desktop>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 02 Jan 2015 09:42:01 +0200
Message-ID: <87bnmh1vee.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jan 2015, Andrey Skvortsov <andrej.skvortzov@gmail.com> wrote:
> Hi,
>
> this warning does not exist in 3.19-rc1, but it happens every boot in
> 3.19-rc2. If you need any other information or data, I would be glad
> to help to debug it.

Hmm, at a glance I can't find a commit that could be the culprit. Can
you bisect between rc1 and rc2 to find the bad commit?

Thanks,
Jani.



>
> [   12.848428] ------------[ cut here ]------------
> [   12.848479] WARNING: CPU: 1 PID: 328 at drivers/gpu/drm/i915/intel_display.c:11375 intel_crtc_set_config+0x3de/0xb36 [i915]()
> [   12.848482] WARN_ON(!set->fb && (set->num_connectors != 0))
> [   12.848484] Modules linked in: i915(E) drm_kms_helper(E) drm(E) snd_hda_intel(E) snd_hda_controller(E) i2c_algo_bit(E) snd_hda_codec(E) i2c_core(E) xhci_pci(E) xhci_hcd(E) ehci_pci(E) ehci_hcd(E) usbcore(E) snd_hwdep(E) snd_pcm_oss(E) snd_mixer_oss(E) snd_pcm(E) snd_seq_midi(E) snd_rawmidi(E) snd_seq_midi_event(E) snd_seq(E) snd_timer(E) snd_seq_device(E) snd(E) video(E) battery(E) ppdev(E) parport_pc(E) usb_common(E) serio_raw(E) lpc_ich(E) evdev(E) mfd_core(E) soundcore(E) button(E) acpi_cpufreq(E) processor(E) coretemp(E) lp(E) parport(E) ext3(E) jbd(E) mbcache(E) sd_mod(E) ata_generic(E) btrfs(E) ata_piix(E) pata_via(E) libata(E) raid6_pq(E) thermal(E) scsi_mod(E) fan(E) thermal_sys(E) r8169(E) mii(E) xor(E) zlib_deflate(E) crc32c_generic(E) libcrc32c(E)
> [   12.848531] CPU: 1 PID: 328 Comm: plymouthd Tainted: G            E  3.19.0-rc2-noiommu- #122
> [   12.848532] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [   12.848533]  0000000000000000 ffffffffa06b3002 ffffffff813c01df ffff8800378afcb8
> [   12.848535]  ffffffff8103f24b 0000000000000000 ffffffffa06685d8 ffff880000110880
> [   12.848537]  ffff8800c83c2d00 ffff8800c8ccb160 ffff8800376c1000 ffff88011a74e000
> [   12.848539] Call Trace:
> [   12.848544]  [<ffffffff813c01df>] ? dump_stack+0x4a/0x74
> [   12.848548]  [<ffffffff8103f24b>] ? warn_slowpath_common+0x9e/0xb7
> [   12.848566]  [<ffffffffa06685d8>] ? intel_crtc_set_config+0x3de/0xb36 [i915]
> [   12.848568]  [<ffffffff8103f30f>] ? warn_slowpath_fmt+0x4a/0x4f
> [   12.848584]  [<ffffffffa06685d8>] ? intel_crtc_set_config+0x3de/0xb36 [i915]
> [   12.848586]  [<ffffffff813c228f>] ? __ww_mutex_lock+0x1c/0x91
> [   12.848598]  [<ffffffffa0592985>] ? drm_mode_set_config_internal+0x53/0xd7 [drm]
> [   12.848604]  [<ffffffffa05f6f15>] ? restore_fbdev_mode+0xae/0xca [drm_kms_helper]
> [   12.848608]  [<ffffffffa05f8393>] ? drm_fb_helper_restore_fbdev_mode_unlocked+0x24/0x5a [drm_kms_helper]
> [   12.848627]  [<ffffffffa06747ea>] ? intel_fbdev_restore_mode+0x1b/0x41 [i915]
> [   12.848632]  [<ffffffffa0589249>] ? drm_lastclose+0x3c/0x104 [drm]
> [   12.848637]  [<ffffffffa0589732>] ? drm_release+0x421/0x457 [drm]
> [   12.848639]  [<ffffffff8112cd65>] ? __fput+0xdb/0x177
> [   12.848642]  [<ffffffff81054977>] ? task_work_run+0x8e/0xa3
> [   12.848645]  [<ffffffff81002814>] ? do_notify_resume+0x64/0x7a
> [   12.848647]  [<ffffffff813c4267>] ? int_signal+0x12/0x17
> [   12.848649] ---[ end trace da6972fb56a05968 ]---
>
> -- 
> Best regards,
> Andrey Skvortsov
>
> Secure e-mail with gnupg: See http://www.gnupg.org/
> PGP Key ID: 0x57A3AEAD
>
>

-- 
Jani Nikula, Intel Open Source Technology Center
