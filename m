Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3BCOV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:21:59 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39205 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3BCOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:21:53 -0500
MIME-Version: 1.0
X-Originating-IP: [116.14.103.70]
Date: Sun, 3 Feb 2013 22:21:51 +0800
Message-ID: <CAMVG2suXHz2ZhikrTa0j3gFc+_c7rdu0qFrXD3sve9JwfyzFAQ@mail.gmail.com>
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to
 gigabit ethernet adapter driver
From: Daniel J Blueman <daniel@quora.org>
To: Freddy Xin <freddy@asix.com.tw>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Freddy,

> Michael, could you give me more information about how do you test this driver?
> I have tried to reproduce the issue by using "ifconfig ethX mtu 1500", but I didn't confront the same issue.
> Thank you in advance for your help.

I found the same by just starting with 'ifconfig eth0 1500' and
testing as high as 4000; pinging another host with a large payload of
size mtu-40 starts failing; after ~30s, I see the transmit time out
trace [1].

Of course, a default MTU size of 1500 is essential to avoid
fragmentation issues, so should be fixed too. Jumbo frames support is
essential these days too.

Thanks,
  Daniel

--- [1]

usb 4-1: new SuperSpeed USB device number 3 using xhci_hcd
ax88179_178a 4-1:1.0 eth0: register 'ax88179_178a' at
usb-0000:00:14.0-1, ASIX AX88179 USB 3.0 Gigibit Ethernet,
00:0a:cd:21:46:a7
ax88179_178a 4-1:1.0 eth2: ax88179 - Link status is: 1
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:254 dev_watchdog+0x26b/0x280()
Hardware name: MacBookPro10,1
NETDEV WATCHDOG: eth2 (ax88179_178a): transmit queue 0 timed out
Modules linked in: fuse snd_hda_codec_hdmi snd_hda_codec_cirrus joydev
hid_apple bcm5974 coretemp kvm_intel kvm ghash_clmulni_intel b43 ssb
ax88179_178a usbnet mii uvcvideo videobuf2_core videobuf2_vmalloc
videobuf2_memops applesmc input_polldev microcode bcma bnep rfcomm
lpc_ich mfd_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm nouveau
apple_gmux snd_timer i915 ttm drm_kms_helper snd hwmon binfmt_misc
mxm_wmi snd_page_alloc video apple_bl nls_iso8859_1
Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc6-expert+ #2
Call Trace:
 <IRQ> [<ffffffff81408d00>] ? dev_watchdog+0x250/0x280
 [<ffffffff8103f8ea>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103f9c1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81408d1b>] dev_watchdog+0x26b/0x280
 [<ffffffff81408ab0>] ? pfifo_fast_dequeue+0xe0/0xe0
 [<ffffffff8104db84>] call_timer_fn+0x74/0xf0
 [<ffffffff8104db10>] ? usleep_range+0x40/0x40
 [<ffffffff81408ab0>] ? pfifo_fast_dequeue+0xe0/0xe0
 [<ffffffff8104df0b>] run_timer_softirq+0x18b/0x220
 [<ffffffff81047ad2>] __do_softirq+0xc2/0x180
 [<ffffffff8108b3ff>] ? tick_program_event+0x1f/0x30
 [<ffffffff813b18d0>] ? read_measured_perf_ctrs+0x70/0x70
 [<ffffffff8154647c>] call_softirq+0x1c/0x30
 [<ffffffff810042ed>] do_softirq+0x7d/0xb0
 [<ffffffff81047d2e>] irq_exit+0x9e/0xc0
 [<ffffffff81022779>] smp_apic_timer_interrupt+0x69/0xa0
 [<ffffffff81545ddc>] apic_timer_interrupt+0x6c/0x80
 <EOI> [<ffffffff8104e884>] ? get_next_timer_interrupt+0x1c4/0x290
 [<ffffffff813b21a0>] ? cpuidle_wrap_enter+0x50/0x90
 [<ffffffff813b219c>] ? cpuidle_wrap_enter+0x4c/0x90
 [<ffffffff813b1900>] cpuidle_enter_tk+0x10/0x20
 [<ffffffff813b1f3c>] cpuidle_idle_call+0x7c/0x110
 [<ffffffff8100b7ba>] cpu_idle+0x7a/0xf0
 [<ffffffff8152b954>] rest_init+0x144/0x150
 [<ffffffff8152b810>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81ab49e6>] ? efi_free_boot_services+0x53/0x58
 [<ffffffff81aa3ad9>] start_kernel+0x359/0x366
 [<ffffffff81aa3580>] ? repair_env_string+0x5e/0x5e
 [<ffffffff81aa32a5>] x86_64_start_reservations+0x131/0x135
 [<ffffffff81aa3120>] ? early_idt_handlers+0x120/0x120
 [<ffffffff81aa337c>] x86_64_start_kernel+0xd3/0xd7
---[ end trace 58c12634a365560a ]---
-- 
Daniel J Blueman
