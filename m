Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3FBHrC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 03:47:02 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:36590 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3FBHqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 03:46:53 -0400
Message-ID: <51AAF869.8050906@t-online.de>
Date: Sun, 02 Jun 2013 09:46:49 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: [BUG 3.9.4] pipe_off wait timed out
Content-Type: multipart/mixed;
 boundary="------------000208070400070709000406"
X-ID: rPDgu-Z68heXxvWqSbw8TSc-GjLMasliIrUBffFoxUOr3o6UTItl+tniUrFiYNJwHd
X-TOI-MSGID: ff08838f-b51b-4992-af62-5dd1ec00fbf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000208070400070709000406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

During booting kernel 3.9.4 on an AOpen i915GMm-hfs, Pentium-M Dothan 2GHz, 2GB RAM
system the "pipe_off wait timed out" warning was triggered. Reproducibility: low, problem was
found only once.

cu,
  Knut

--------------000208070400070709000406
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[   16.276006] =============================================
[   16.276006] [ INFO: possible recursive locking detected ]
[   16.276006] 3.9.4-main #26 Not tainted
[   16.276006] ---------------------------------------------
[   16.276006] systemd-udevd/259 is trying to acquire lock:
[   16.276006]  (hdl->lock){+.+...}, at: [<f851437e>] find_ref_lock+0x1c/0x39 [videodev]
[   16.276006] 
[   16.276006] but task is already holding lock:
[   16.276006]  (hdl->lock){+.+...}, at: [<f8514fe0>] v4l2_ctrl_add_handler+0x36/0xa3 [videodev]
[   16.276006] 
[   16.276006] other info that might help us debug this:
[   16.276006]  Possible unsafe locking scenario:
[   16.276006] 
[   16.276006]        CPU0
[   16.276006]        ----
[   16.276006]   lock(hdl->lock);
[   16.276006]   lock(hdl->lock);
[   16.276006] 
[   16.276006]  *** DEADLOCK ***
[   16.276006] 
[   16.276006]  May be due to missing lock nesting notation
[   16.276006] 
[   16.276006] 3 locks held by systemd-udevd/259:
[   16.276006]  #0:  (&__lockdep_no_validate__){......}, at: [<c03dbfdb>] __driver_attach+0x35/0x6f
[   16.276006]  #1:  (&__lockdep_no_validate__){......}, at: [<c03dbfe7>] __driver_attach+0x41/0x6f
[   16.276006]  #2:  (hdl->lock){+.+...}, at: [<f8514fe0>] v4l2_ctrl_add_handler+0x36/0xa3 [videodev]
[   16.276006] 
[   16.276006] stack backtrace:
[   16.276006] Pid: 259, comm: systemd-udevd Not tainted 3.9.4-main #26
[   16.276006] Call Trace:
[   16.276006]  [<c0127bb9>] ? vprintk_emit+0x392/0x3da
[   16.276006]  [<c015a9fc>] __lock_acquire+0xcaa/0x1407
[   16.276006]  [<c015bb35>] ? mark_held_locks+0x9e/0xc1
[   16.276006]  [<c015b57b>] lock_acquire+0x9b/0xd5
[   16.276006]  [<f851437e>] ? find_ref_lock+0x1c/0x39 [videodev]
[   16.276006]  [<f851437e>] ? find_ref_lock+0x1c/0x39 [videodev]
[   16.276006]  [<c050e5d3>] mutex_lock_nested+0x3a/0x255
[   16.276006]  [<f851437e>] ? find_ref_lock+0x1c/0x39 [videodev]
[   16.276006]  [<c050e7ac>] ? mutex_lock_nested+0x213/0x255
[   16.276006]  [<c050e7d3>] ? mutex_lock_nested+0x23a/0x255
[   16.276006]  [<f851437e>] find_ref_lock+0x1c/0x39 [videodev]
[   16.276006]  [<f8514968>] handler_new_ref+0x37/0x148 [videodev]
[   16.276006]  [<f851500c>] v4l2_ctrl_add_handler+0x62/0xa3 [videodev]
[   16.276006]  [<f853d988>] cx8800_initdev+0x30f/0x66d [cx8800]
[   16.276006]  [<c0513288>] ? sub_preempt_count+0x84/0xa1
[   16.276006]  [<c0510734>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[   16.276006]  [<c03e10b9>] ? __pm_runtime_resume+0x40/0x48
[   16.276006]  [<c02f14a3>] pci_device_probe+0x5e/0x96
[   16.276006]  [<c03dbeb2>] driver_probe_device+0x83/0x177
[   16.276006]  [<c03dbff9>] __driver_attach+0x53/0x6f
[   16.276006]  [<c03daa16>] bus_for_each_dev+0x43/0x6d
[   16.276006]  [<c03dbafe>] driver_attach+0x19/0x1b
[   16.276006]  [<c03dbfa6>] ? driver_probe_device+0x177/0x177
[   16.276006]  [<c03db798>] bus_add_driver+0xc3/0x1c0
[   16.276006]  [<f8545000>] ? 0xf8544fff
[   16.276006]  [<f8545000>] ? 0xf8544fff
[   16.276006]  [<c03dc350>] driver_register+0x79/0xf1
[   16.276006]  [<c02e5578>] ? __raw_spin_lock_init+0x26/0x49
[   16.276006]  [<f8545000>] ? 0xf8544fff
[   16.276006]  [<c02f1586>] __pci_register_driver+0x4a/0x4d
[   16.276006]  [<f8545026>] cx8800_init+0x26/0x1000 [cx8800]
[   16.276006]  [<c010108d>] do_one_initcall+0x6f/0x10e
[   16.276006]  [<f8545000>] ? 0xf8544fff
[   16.276006]  [<c0163909>] load_module+0x164f/0x1931
[   16.276006]  [<c0163c5b>] sys_init_module+0x70/0x85
[   16.276006]  [<c0510b3d>] syscall_call+0x7/0xb
[   16.498868] ------------[ cut here ]------------
[   16.501906] WARNING: at drivers/gpu/drm/i915/intel_display.c:984 intel_wait_for_pipe_off+0x149/0x154()
[   16.509753] Hardware name:  
[   16.518599] pipe_off wait timed out
[   16.521005] cx88[0]/0: registered device video0 [v4l2]
[   16.523303] Modules linked in: videobuf_dvb dvb_core ir_lirc_codec lirc_dev ir_rc5_decoder rc_hauppauge snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_seq tuner snd_timer snd_seq_device snd_mixer_oss cx8802(+) cx8800(+) cx88xx snd v4l2_common videodev rc_core tveeprom videobuf_dma_sg videobuf_core btcx_risc soundcore snd_page_alloc
[   16.530840] Pid: 379, comm: plymouthd Not tainted 3.9.4-main #26
[   16.537675] Call Trace:
[   16.542841]  [<c0125b89>] warn_slowpath_common+0x68/0x7f
[   16.546954]  [<c03aa42e>] ? intel_wait_for_pipe_off+0x149/0x154
[   16.550899]  [<c0125c13>] warn_slowpath_fmt+0x2b/0x2f
[   16.554127] cx88[0]/0: registered device vbi0
[   16.556917]  [<c03aa42e>] intel_wait_for_pipe_off+0x149/0x154
[   16.559594]  [<c03c73b5>] intel_tv_mode_set+0x4c4/0x620
[   16.566720]  [<c03ac37f>] __intel_set_mode+0x595/0x6b1
[   16.572037]  [<c015bb35>] ? mark_held_locks+0x9e/0xc1
[   16.574734]  [<c03b11cf>] intel_set_mode+0x17/0x2f
[   16.580456]  [<c03b1ef7>] intel_get_load_detect_pipe+0x2b4/0x308
[   16.586534]  [<c050e8c8>] ? __mutex_unlock_slowpath+0xda/0xf4
[   16.591214]  [<c015bc5f>] ? trace_hardirqs_on_caller+0x107/0x156
[   16.594205]  [<c015bcb9>] ? trace_hardirqs_on+0xb/0xd
[   16.598037]  [<c03c7752>] intel_tv_detect+0xd1/0x3ea
[   16.601102]  [<c0376cdd>] drm_helper_probe_single_connector_modes+0xa0/0x263
[   16.603877]  [<c0385472>] drm_mode_getconnector+0xc2/0x2a8
[   16.608327]  [<c01b0eb0>] ? might_fault+0x2e/0x6c
[   16.611095]  [<c03853b0>] ? drm_mode_getcrtc+0xac/0xac
[   16.614837]  [<c037a927>] drm_ioctl+0x27c/0x32b
[   16.618451]  [<c03853b0>] ? drm_mode_getcrtc+0xac/0xac
[   16.621830] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   16.625248]  [<c04c64a7>] ? tcp_urg+0xa0/0x17b
[   16.627977] cx88/2: registering cx8802 driver, type: dvb access: shared
[   16.632029] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   16.634894] cx88[0]/2: cx2388x based DVB/ATSC card
[   16.639982]  [<c037a6ab>] ? drm_copy_field+0x54/0x54
[   16.643313]  [<c01d3014>] vfs_ioctl+0x20/0x2a
[   16.646196] cx8802_alloc_frontends() allocating 1 frontend(s)
[   16.649368]  [<c01d3a64>] do_vfs_ioctl+0x42d/0x46b
[   16.656996]  [<c051307a>] ? __do_page_fault+0x3fb/0x480
[   16.662587]  [<c0179482>] ? rcu_irq_exit+0x73/0x81
[   16.666473]  [<c02e0804>] ? trace_hardirqs_on_thunk+0xc/0x10
[   16.671748]  [<c01d3ae3>] sys_ioctl+0x41/0x62
[   16.675890] DVB: registering new adapter (cx88[0])
[   16.679319]  [<c04c64a7>] ? tcp_urg+0xa0/0x17b
[   16.682249] cx88-mpeg driver manager 0000:05:05.2: DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[   16.690170]  [<c0510b3d>] syscall_call+0x7/0xb
[   16.693783]  [<c04c64a7>] ? tcp_urg+0xa0/0x17b
[   16.696926]  [<c04c64a7>] ? tcp_urg+0xa0/0x17b
[   16.700903] ---[ end trace d6a6a8489005d7da ]---

--------------000208070400070709000406--
