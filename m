Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3I1THo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:07:44 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:47871 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3I1THl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:07:41 -0400
X-Greylist: delayed 1037 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Sep 2013 15:07:41 EDT
Date: Sat, 28 Sep 2013 14:50:23 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Intel Haswell kernel warning (3.11.2)
Message-ID: <20130928185023.GA21672@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep me in CC.

I receive a warning in drivers/gpu/drm/i915/intel_display.c:3869.  This
happens when I'm on a console, the screen has gone into power save and I
press a key to wake it up.

This doesn't happen when I'm in X.

Kernel is Vanilla 3.11.2.

# lspci -vns2
00:02.0 0300: 8086:041a (rev 06) (prog-if 00 [VGA controller])
        Subsystem: 8086:2010
        Flags: bus master, fast devsel, latency 0, IRQ 57
        Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at f000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Capabilities: [a4] PCI Advanced Features
        Kernel driver in use: i915
#

gcc version 4.8.1 (Debian 4.8.1-10)

This is from dmesg:
[  354.803050] ------------[ cut here ]------------
[  354.803064] WARNING: CPU: 0 PID: 482 at /usr/src/linux/dist/3.11.2/drivers/gpu/drm/i915/intel_display.c:3869 intel_modeset_check_state+0x764/0x770 [i915]()
[  354.803064] wrong connector dpms state
[  354.803084] Modules linked in: nfsd auth_rpcgss oid_registry exportfs nfs lockd sunrpc xt_nat iptable_nat nf_nat_ipv4 nf_nat xt_limit xt_LOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT ipv6 xt_recent xt_conntrack nf_conntrack iptable_filter ip_tables x_tables snd_hda_codec_realtek snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_intel coretemp kvm_intel snd_hda_codec i915 kvm snd_hwdep snd_pcm_oss snd_mixer_oss crc32_pclmul snd_pcm crc32c_intel e1000e intel_agp igb ghash_clmulni_intel intel_gtt aesni_intel cfbfillrect aes_x86_64 cfbimgblt lrw cfbcopyarea drm_kms_helper ptp video thermal processor gf128mul snd_page_alloc drm snd_timer glue_helper 8250_pci snd pps_core ablk_helper agpgart cryptd sg soundcore fan i2c_algo_bit sr_mod thermal_sys 8250 i2c_i801 serial_core hwmon cdrom i2c_core evdev button
[  354.803086] CPU: 0 PID: 482 Comm: kworker/0:1 Not tainted 3.11.2 #1
[  354.803087] Hardware name: Supermicro X10SAE/X10SAE, BIOS 1.00 05/03/2013
[  354.803091] Workqueue: events console_callback
[  354.803092]  0000000000000009 ffff88023611db48 ffffffff814048ac ffff88023611db90
[  354.803093]  ffff88023611db80 ffffffff8103d4e3 ffff880230d82800 ffff880230f9b800
[  354.803094]  ffff880230f99000 ffff880230f99448 ffff8802351c0e00 ffff88023611dbe0
[  354.803094] Call Trace:
[  354.803098]  [<ffffffff814048ac>] dump_stack+0x54/0x8d
[  354.803101]  [<ffffffff8103d4e3>] warn_slowpath_common+0x73/0x90
[  354.803103]  [<ffffffff8103d547>] warn_slowpath_fmt+0x47/0x50
[  354.803109]  [<ffffffffa089f1be>] ? intel_ddi_connector_get_hw_state+0x5e/0x110 [i915]
[  354.803114]  [<ffffffffa0896974>] intel_modeset_check_state+0x764/0x770 [i915]
[  354.803117]  [<ffffffffa08969bb>] intel_connector_dpms+0x3b/0x60 [i915]
[  354.803120]  [<ffffffffa037e1d0>] drm_fb_helper_dpms.isra.11+0x120/0x160 [drm_kms_helper]
[  354.803122]  [<ffffffffa037e24e>] drm_fb_helper_blank+0x3e/0x80 [drm_kms_helper]
[  354.803123]  [<ffffffff812116c2>] fb_blank+0x52/0xc0
[  354.803125]  [<ffffffff8121e04b>] fbcon_blank+0x21b/0x2d0
[  354.803127]  [<ffffffff81062243>] ? update_rq_clock.part.74+0x13/0x30
[  354.803129]  [<ffffffff81047486>] ? lock_timer_base.isra.30+0x26/0x50
[  354.803130]  [<ffffffff810472b2>] ? internal_add_timer+0x12/0x40
[  354.803131]  [<ffffffff81047f48>] ? mod_timer+0xf8/0x1c0
[  354.803133]  [<ffffffff81266d61>] do_unblank_screen+0xa1/0x1c0
[  354.803134]  [<ffffffff81268087>] poke_blanked_console+0xc7/0xd0
[  354.803136]  [<ffffffff812681cf>] console_callback+0x13f/0x160
[  354.803137]  [<ffffffff81053258>] process_one_work+0x148/0x3d0
[  354.803138]  [<ffffffff81053f19>] worker_thread+0x119/0x3a0
[  354.803140]  [<ffffffff81053e00>] ? manage_workers.isra.30+0x2a0/0x2a0
[  354.803141]  [<ffffffff8105994b>] kthread+0xbb/0xc0
[  354.803142]  [<ffffffff81059890>] ? kthread_create_on_node+0x120/0x120
[  354.803144]  [<ffffffff8140b32c>] ret_from_fork+0x7c/0xb0
[  354.803145]  [<ffffffff81059890>] ? kthread_create_on_node+0x120/0x120
[  354.803145] ---[ end trace 590553ce6c6f5fa9 ]---

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
