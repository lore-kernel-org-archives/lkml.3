Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3HMJUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:20:25 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65123 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3HMJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:20:23 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUtC6V-E=vcpebDmSGZwKBwyVC4aiZxC_TsP6UiY2vq+g@mail.gmail.com>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
	<CA+icZUUtC6V-E=vcpebDmSGZwKBwyVC4aiZxC_TsP6UiY2vq+g@mail.gmail.com>
Date: Tue, 13 Aug 2013 11:20:21 +0200
Message-ID: <CA+icZUVVGTBSmm7Z2705TNuseea7_8Z+-r81DgSQNprcNQLW2w@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:14 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 13, 2013 at 11:10 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Aug 13, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130812:
>>>
>>> The ext4 tree gained a conflict against Linus' tree.
>>>
>>> The infiniband tree gained a build failure for which I applied a merge
>>> fix patch and another so I used the version from next-20130812.
>>>
>>> The tty tree gained conflicts against the devicetree and tile trees.
>>>
>>> The usb tree gained a conflict against the net-next tree.
>>>
>>> The usb-gadget tree gained a build failure for which I reverted a commit.
>>>
>>> The ptr-ret tree gained a conflict against the staging tree.
>>>
>>> The akpm tree gained a conflict against the staging tree.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> Hi,
>>
>> with today's next-20130813 I cannot see 1/10 of my desktop-screen's
>> top, it's simply black.
>> I can estimate the URL line in Firefox (or open a new tab blindly and
>> get a known URL from my autocompleted history).
>>
>> My Xorg stack did not change: libdrm-2.4.46 | mesa-9.16 | intel-ddx-2.4.14.
>> next-20130808 was OK - no screen corruptions.
>>
>> Any idea, hint?
>>
>> - Sedat -
>
> [ From my dmesg ]
>
> [   28.026524] ------------[ cut here ]------------
> [   28.026557] WARNING: CPU: 3 PID: 639 at
> drivers/gpu/drm/i915/i915_gem.c:3435
> i915_gem_object_set_cache_level+0x389/0x3a0 [i915]()
> [   28.026560] Modules linked in: arc4 snd_hwdep i915(+) iwldvm
> snd_pcm snd_page_alloc mac80211 snd_seq_midi parport_pc
> snd_seq_midi_event rfcomm bnep snd_rawmidi ppdev uvcvideo snd_seq
> btusb videobuf2_vmalloc i2c_algo_bit psmouse iwlwifi drm_kms_helper
> videobuf2_memops snd_timer drm snd_seq_device videobuf2_core bluetooth
> videodev serio_raw snd cfg80211 samsung_laptop wmi soundcore lp
> mac_hid video lpc_ich parport hid_generic usbhid hid usb_storage r8169
> mii
> [   28.026610] CPU: 3 PID: 639 Comm: modprobe Not tainted
> 3.11.0-rc5-next20130813-1-iniza-small #1
> [   28.026613] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
> [   28.026616]  0000000000000d6b ffff8800795535a8 ffffffff816e259a
> 0000000000000007
> [   28.026622]  0000000000000000 ffff8800795535e8 ffffffff810661dc
> ffffffff81376e70
> [   28.026627]  ffff8800746ba200 ffff8800746ba2b8 ffff88007a2c7000
> 0000000000000041
> [   28.026632] Call Trace:
> [   28.026641]  [<ffffffff816e259a>] dump_stack+0x46/0x58
> [   28.026647]  [<ffffffff810661dc>] warn_slowpath_common+0x8c/0xc0
> [   28.026653]  [<ffffffff81376e70>] ? sg_kfree+0x30/0x30
> [   28.026658]  [<ffffffff8106622a>] warn_slowpath_null+0x1a/0x20
> [   28.026680]  [<ffffffffa03e1fe9>]
> i915_gem_object_set_cache_level+0x389/0x3a0 [i915]
> [   28.026684]  [<ffffffff8137723f>] ? sg_alloc_table+0x1f/0x50
> [   28.026703]  [<ffffffffa03e2162>]
> i915_gem_object_pin_to_display_plane+0x62/0x1c0 [i915]
> [   28.026727]  [<ffffffffa03f9b10>]
> intel_pin_and_fence_fb_obj+0xc0/0x140 [i915]
> [   28.026732]  [<ffffffff816e82ee>] ? mutex_lock+0x1e/0x40
> [   28.026761]  [<ffffffffa0424277>] intelfb_create+0x107/0x510 [i915]
> [   28.026778]  [<ffffffffa020f807>] ? drm_mode_create+0x47/0x70 [drm]
> [   28.026786]  [<ffffffffa01a404e>]
> drm_fb_helper_initial_config+0x2fe/0x550 [drm_kms_helper]
> [   28.026813]  [<ffffffffa0431323>] ? i915_write32+0xc3/0x190 [i915]
> [   28.026838]  [<ffffffffa0424751>] intel_fbdev_initial_config+0x21/0x30 [i915]
> [   28.026859]  [<ffffffffa03cb38d>] i915_driver_load+0xe9d/0xed0 [i915]
> [   28.026876]  [<ffffffffa020aad1>] drm_get_pci_dev+0x181/0x2a0 [drm]
> [   28.026881]  [<ffffffff8137b12d>] ? do_raw_spin_unlock+0x5d/0xb0
> [   28.026900]  [<ffffffffa03c75d6>] i915_pci_probe+0x36/0x70 [i915]
> [   28.026905]  [<ffffffff81399ceb>] local_pci_probe+0x4b/0x80
> [   28.026910]  [<ffffffff8139b5c1>] pci_device_probe+0x101/0x120
> [   28.026915]  [<ffffffff81478a1b>] driver_probe_device+0x7b/0x240
> [   28.026920]  [<ffffffff81478c8b>] __driver_attach+0xab/0xb0
> [   28.026924]  [<ffffffff81478be0>] ? driver_probe_device+0x240/0x240
> [   28.026928]  [<ffffffff81476b6e>] bus_for_each_dev+0x5e/0x90
> [   28.026932]  [<ffffffff8147851e>] driver_attach+0x1e/0x20
> [   28.026936]  [<ffffffff81477fc4>] bus_add_driver+0x104/0x2a0
> [   28.026941]  [<ffffffff814793f4>] driver_register+0x64/0xf0
> [   28.026946]  [<ffffffff8139a544>] __pci_register_driver+0x64/0x70
> [   28.026951]  [<ffffffffa0475000>] ? 0xffffffffa0474fff
> [   28.026963]  [<ffffffffa020ad0a>] drm_pci_init+0x11a/0x130 [drm]
> [   28.026968]  [<ffffffffa0475000>] ? 0xffffffffa0474fff
> [   28.026987]  [<ffffffffa0475066>] i915_init+0x66/0x68 [i915]
> [   28.026992]  [<ffffffff8100207e>] do_one_initcall+0x4e/0x180
> [   28.026997]  [<ffffffff81058413>] ? set_memory_nx+0x43/0x50
> [   28.027003]  [<ffffffff810d147c>] load_module+0x209c/0x25b0
> [   28.027007]  [<ffffffff810ce0a0>] ? show_initstate+0x50/0x50
> [   28.027013]  [<ffffffff810d1a3c>] SyS_init_module+0xac/0xd0
> [   28.027018]  [<ffffffff816f41ef>] tracesys+0xe1/0xe6
> [   28.027022] ---[ end trace be830cf8c302dde8 ]---
>
>
> - Sedat -

Looks like there is patch to fix this WARNING, do not think it fixes
my screen corruption.

- Sedat -

http://lists.freedesktop.org/archives/intel-gfx/2013-August/031701.html
