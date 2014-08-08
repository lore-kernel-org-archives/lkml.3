Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaHHUwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:52:24 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49370 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaHHUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyXXyJ1subAWjwv3-yFndRNpUSWLFVb8Aq=NWAS+PXsJQ@mail.gmail.com>
References: <20140808143418.GA25720@phenom.ffwll.local>
	<CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
	<CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
	<CA+55aFyXXyJ1subAWjwv3-yFndRNpUSWLFVb8Aq=NWAS+PXsJQ@mail.gmail.com>
Date: Fri, 8 Aug 2014 10:52:08 -1000
X-Google-Sender-Auth: JfFU3YYHAg4ya6ng9UiGr6zMGj4
Message-ID: <CA+55aFzxF8WGM6C9eoqP+Xd+AWRw079s5L_YJd-jJTJGJssi=A@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 10:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is a Sony Vaio Pro 11, so it's bog-standard intel graphics (Haswell ULT).

Got this while bisecting. I'm not sure it's related, the behavior was
a bit different from the other cases. So I'll try to continue
bisecting, but am a bit worried that there are two possibly unrelated
problems here..

   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 1074 at
drivers/gpu/drm/i915/intel_display.c:1234 intel_enable_pipe+0x3f/0x200
[i915]()
   cursor on pipe A assertion failure (expected off, current on)
   Modules linked in: rfcomm fuse ccm ip6t_rpfilter ip6t_REJECT
xt_conntrack mmc_block ebtable_nat ebtable_broute bridge stp llc
ebtable_filter ebtables ip6table_nat n$
    snd_pcm media btusb bluetooth hid_multitouch iwlwifi snd_timer
rtsx_pci i2c_i801 cfg80211 lpc_ich mfd_core mei_me snd mei shpchp
soundcore sony_laptop rfkill dm_cr$
   CPU: 0 PID: 1074 Comm: Xorg Not tainted 3.16.0-rc4-00378-g4dac3edfe68e #15
   Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS R0270V7 05/17/2013
   Call Trace:
     ? dump_stack+0x41/0x51
     ? warn_slowpath_common+0x6d/0x90
     ? warn_slowpath_fmt+0x47/0x50
     ? intel_enable_pipe+0x3f/0x200 [i915]
     ? haswell_crtc_enable+0x425/0xa70 [i915]
     ? intel_crtc_update_dpms+0x5e/0x70 [i915]
     ? intel_connector_dpms+0x39/0x70 [i915]
     ? drm_mode_obj_set_property_ioctl+0x396/0x3b0 [drm]
     ? drm_mode_connector_property_set_ioctl+0x29/0x30 [drm]
     ? drm_ioctl+0x178/0x580 [drm]
     ? do_vfs_ioctl+0x2cf/0x4b0
     ? file_has_perm+0x86/0xa0
     ? __audit_syscall_exit+0x151/0x2a0
     ? SyS_ioctl+0x79/0x90
     ? __audit_syscall_exit+0x1f6/0x2a0
     ? system_call_fastpath+0x16/0x1b
   ---[ end trace 86461bbc6e1418cd ]---

Does that make sense to anybody?

              Linus
