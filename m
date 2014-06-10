Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaFJG1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:27:09 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60808 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaFJG1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:27:06 -0400
Date: Tue, 10 Jun 2014 08:26:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Mismatch in gmch_pfit.lvds_border_bits on EeePC 900
Message-ID: <20140610062655.GA5821@phenom.ffwll.local>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20140608213015.GA30713@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608213015.GA30713@sucs.org>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 10:30:15PM +0100, Sitsofe Wheeler wrote:
> With a tree that is close to 3.15 final I'm regularly seeing the
> following on my EeePC 900 when starting ioquake3:
> 
> [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)

Hm, I've thought we've fixed that by now. Alas, no :(

Can you please add drm.debug=0xe to your kernel cmdline, reproduce the
issue and attach the entire dmesg? Please make sure it contains everything
since boot-up so that we can reconstruct the state properly (might need to
grab it from logfiles if dmesg is cut off).

Also, do you have any ideas when you reproduce this? Anything that changes
the lvds output could be relevant ...
-Daniel

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1594 at drivers/gpu/drm/i915/intel_display.c:9834 check_crtc_state+0x998/0x9ef()
> pipe state doesn't match!
> CPU: 0 PID: 1594 Comm: Xorg Not tainted 3.15.0-rc8-00106-ge585b54 #49
> Hardware name: ASUSTeK Computer INC. 900/900, BIOS 1006    03/03/2009
>  b0485438 b011f61f b057c98a ebb03b04 0000063a b057b5f4 0000266a b02c31ef
>  b02c31ef ee42c000 ee488c00 00000000 ee488d74 b011f684 00000009 ebb03aec
>  b057c98a ebb03b04 b02c31ef b057b5f4 0000266a b057c98a 00000000 ebb03bdc
> Call Trace:
>  [<b0485438>] ? dump_stack+0xa/0x13
>  [<b011f61f>] ? warn_slowpath_common+0x70/0x85
>  [<b02c31ef>] ? check_crtc_state+0x998/0x9ef
>  [<b02c31ef>] ? check_crtc_state+0x998/0x9ef
>  [<b011f684>] ? warn_slowpath_fmt+0x33/0x37
>  [<b02c31ef>] ? check_crtc_state+0x998/0x9ef
>  [<b02cdbe6>] ? intel_modeset_check_state+0x353/0x5fb
>  [<b02cdefd>] ? intel_set_mode+0x2a/0x32
>  [<b02cebfd>] ? intel_crtc_set_config+0x8c9/0x962
>  [<b02151e4>] ? idr_alloc+0xb5/0xc3
>  [<b0292d68>] ? drm_mode_set_config_internal+0x39/0x9b
>  [<b0293325>] ? drm_mode_setcrtc+0x397/0x438
>  [<b0292f8e>] ? drm_crtc_check_viewport+0xef/0xef
>  [<b028a871>] ? drm_ioctl+0x327/0x38f
>  [<b0292f8e>] ? drm_crtc_check_viewport+0xef/0xef
>  [<b016f5f5>] ? do_sync_read+0x5a/0x7f
>  [<b028a54a>] ? drm_version+0x73/0x73
>  [<b017a883>] ? do_vfs_ioctl+0x350/0x419
>  [<b0125e02>] ? recalc_sigpending+0xe/0x36
>  [<b0126867>] ? __set_task_blocked+0x61/0x67
>  [<b0127ad6>] ? __set_current_blocked+0xd/0xf
>  [<b0127bf9>] ? sigprocmask+0x77/0x87
>  [<b017a97d>] ? SyS_ioctl+0x31/0x54
>  [<b04898c9>] ? sysenter_do_call+0x12/0x26
>  [<b0480000>] ? klist_release+0x14/0x87
> ---[ end trace 900fd39ab2e2b03f ]---
> 
> -- 
> Sitsofe | http://sucs.org/~sits/

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
