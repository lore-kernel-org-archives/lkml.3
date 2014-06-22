Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaFVO00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 10:26:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37220 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaFVO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 10:26:24 -0400
Date: Sun, 22 Jun 2014 16:26:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.16, i915: less colors in X?
Message-ID: <20140622142622.GA4107@amd.pavel.ucw.cz>
References: <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140621202901.GA3840@amd.pavel.ucw.cz>
 <20140621210652.GA14025@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140621210652.GA14025@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-06-21 22:06:52, Chris Wilson wrote:
> On Sat, Jun 21, 2014 at 10:29:01PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > I just test-booted 3.16-rc1, and background in X looked just wrong --
> > very noticeable bands on the background gradient. I thought that maybe
> > it is just my eyes, but I went back to older kernel, and background is
> > ok now.
> > 
> > I'm trying to figure out how to ask X what color depth it is using...?
> > 
> > This is thinkpad x60 with Debian 6.0.9.
> > 
> > Any ideas?
> 
> That suggests that the panel dithering changed. Compare intel_reg_dumper
> output for both kernels, especially PIPE.CONF.

Hmm, I tried:

root@duo:/sys/power# mount -t debugfs debugfs /sys/kernel/debug
root@duo:/sys/power# intel_gpu_dump 
Error opening /sys/kernel/debug/dri/0/i915_ringbuffer_info: No such
file or directory

Perhaps your i915 kernel driver has no support for dumping batchbuffer
data?
(In kernels prior to 2.6.30 this requires manually-applied patches.)
root@duo:/sys/power# ls -al /sys/kernel/debug/dri/0/
bufs                       i915_gem_gtt               i915_pc8_status
clients                    i915_gem_hws               i915_pipe_A_crc
gem_names                  i915_gem_hws_blt           i915_pipe_B_crc
i915_cache_sharing         i915_gem_hws_bsd           i915_pipe_C_crc
i915_capabilities          i915_gem_hws_vebox
i915_power_domain_info
i915_context_status        i915_gem_inactive          i915_ppgtt_info
i915_cur_wm_latency        i915_gem_interrupt
i915_pri_wm_latency
i915_delayfreq_table       i915_gem_objects
i915_ring_freq_table
i915_display_crc_ctl       i915_gem_pageflip
i915_ring_missed_irq
i915_display_info          i915_gem_pinned            i915_ring_stop
i915_drpc_info             i915_gem_request
i915_ring_test_irq
i915_edp_psr_status        i915_gem_seqno
i915_rstdby_delays
i915_emon_status           i915_gem_stolen
i915_sink_crc_eDP1
i915_energy_uJ             i915_gen6_forcewake_count
i915_spr_wm_latency
i915_error_state           i915_gfxec                 i915_sr_status
i915_fbc_status            i915_inttoext_table
i915_swizzle_info
i915_forcewake_user        i915_ips_status            i915_wedged
i915_frequency_info        i915_llc                   name
i915_gem_active            i915_max_freq              vm
i915_gem_drop_caches       i915_min_freq              vma
i915_gem_fence_regs        i915_next_seqno            
i915_gem_framebuffer       i915_opregion              

root@duo:/sys/power# intel_gpu_dump --help
Error opening --help: No such file or directory

root@duo:/sys/power# hexdump /sys/kernel/debug/dri/0/i915_pipe_*_crc
hexdump: /sys/kernel/debug/dri/0/i915_pipe_C_crc: No such device
root@duo:/sys/power# 

I also tried to download the git tree with intel_gpu_dump, but:

pavel@duo:~/g/intel-gpu-tools$ ./autogen.sh 
autoreconf: Entering directory `.'
autoreconf: configure.ac: not using Gettext
autoreconf: running: aclocal ${ACLOCAL_FLAGS} -I m4
configure.ac:68: error: must install xorg-macros 1.16 or later before
running autoconf/autogen
configure.ac:68: the top level
autom4te: /usr/bin/m4 failed with exit status: 1
aclocal: /usr/bin/autom4te failed with exit status: 1
autoreconf: aclocal failed with exit status: 1
pavel@duo:~/g/intel-gpu-tools$ 

Trying to bypass configure script:

pavel@duo:~/g/intel-gpu-tools/tools$ gcc  -I ../lib intel_reg_dumper.c
2>&1  | less

In file included from ../lib/drmtest.h:37,
                 from intel_reg_dumper.c:39:
/usr/include/xf86drm.h:40:17: error: drm.h: No such file or directory
In file included from ../lib/drmtest.h:37,
                 from intel_reg_dumper.c:39:
/usr/include/xf86drm.h:268: error: expected specifier-qualifier-list
                 before ‘drm_context_t’
/usr/include/xf86drm.h:281: error: expected specifier-qualifier-list
                 before ‘drm_handle_t’
/usr/include/xf86drm.h:546: error: expected declaration specifiers or
                 ‘...’ before ‘drm_magic_t’


Is there way to get required info manually?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
