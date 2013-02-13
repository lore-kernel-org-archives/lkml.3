Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3BMF0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 00:26:36 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:38174 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3BMF0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 00:26:35 -0500
Message-ID: <1360733189.3634.8.camel@thor.lan>
Subject: [next-20130204] nouveau: lockdep warning (not the same as the
 subdev lockdep warning)
From: Peter Hurley <peter@hurleysoftware.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 00:26:29 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this lockdep warning straightaway during boot:

[    7.435890] =============================================
[    7.435891] [ INFO: possible recursive locking detected ]
[    7.435893] 3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch Not tainted
[    7.435893] ---------------------------------------------
[    7.435895] modprobe/255 is trying to acquire lock:
[    7.435942]  (&dmac->lock){+.+...}, at: [<ffffffffa01767c3>] evo_wait+0x43/0xf0 [nouveau]
[    7.435942] 
[    7.435942] but task is already holding lock:
[    7.435964]  (&dmac->lock){+.+...}, at: [<ffffffffa01767c3>] evo_wait+0x43/0xf0 [nouveau]
[    7.435964] 
[    7.435964] other info that might help us debug this:
[    7.435965]  Possible unsafe locking scenario:
[    7.435965] 
[    7.435966]        CPU0
[    7.435967]        ----
[    7.435968]   lock(&dmac->lock);
[    7.435970]   lock(&dmac->lock);
[    7.435970] 
[    7.435970]  *** DEADLOCK ***
[    7.435970] 
[    7.435971]  May be due to missing lock nesting notation
[    7.435971] 
[    7.435973] 9 locks held by modprobe/255:
[    7.435979]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff814ce26b>] __driver_attach+0x5b/0xb0
[    7.435982]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff814ce279>] __driver_attach+0x69/0xb0
[    7.436001]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffffa0065e6d>] drm_get_pci_dev+0xbd/0x2a0 [drm]
[    7.436012]  #3:  (registration_lock){+.+.+.}, at: [<ffffffff81402855>] register_framebuffer+0x25/0x2f0
[    7.436016]  #4:  (&fb_info->lock){+.+.+.}, at: [<ffffffff81401736>] lock_fb_info+0x26/0x60
[    7.436023]  #5:  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff81096466>] __blocking_notifier_call_chain+0x56/0xc0
[    7.436035]  #6:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffffa0069d6a>] drm_modeset_lock_all+0x2a/0x70 [drm]
[    7.436046]  #7:  (&crtc->mutex){+.+.+.}, at: [<ffffffffa0069d94>] drm_modeset_lock_all+0x54/0x70 [drm]
[    7.436068]  #8:  (&dmac->lock){+.+...}, at: [<ffffffffa01767c3>] evo_wait+0x43/0xf0 [nouveau]
[    7.436068] 
[    7.436068] stack backtrace:
[    7.436070] Pid: 255, comm: modprobe Not tainted 3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[    7.436072] Call Trace:
[    7.436077]  [<ffffffff810d0e87>] __lock_acquire+0x697/0x1a80
[    7.436080]  [<ffffffff810d28f1>] lock_acquire+0xa1/0x200
[    7.436100]  [<ffffffffa01767c3>] ? evo_wait+0x43/0xf0 [nouveau]
[    7.436121]  [<ffffffffa01767c3>] ? evo_wait+0x43/0xf0 [nouveau]
[    7.436125]  [<ffffffff817946d3>] mutex_lock_nested+0x63/0x3a0
[    7.436145]  [<ffffffffa01767c3>] ? evo_wait+0x43/0xf0 [nouveau]
[    7.436148]  [<ffffffff8179490e>] ? mutex_lock_nested+0x29e/0x3a0
[    7.436168]  [<ffffffffa01767c3>] ? evo_wait+0x43/0xf0 [nouveau]
[    7.436170]  [<ffffffff810d32ef>] ? mark_held_locks+0xaf/0x110
[    7.436190]  [<ffffffffa01767c3>] evo_wait+0x43/0xf0 [nouveau]
[    7.436212]  [<ffffffffa0176d3c>] evo_sync+0x5c/0xf0 [nouveau]
[    7.436233]  [<ffffffffa0178e7d>] nv50_display_flip_next+0x5ad/0x5c0 [nouveau]


Regards,
Peter Hurley

