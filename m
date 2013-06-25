Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FYP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:28:39 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:58408 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FYP2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:28:37 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-de-51c9b723116a
From: Shuah Khan <shuah.kh@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: Linux 3.10-rc7
Thread-topic: Linux 3.10-rc7
Thread-index: AQHOcO9Wy94BEELWoUiZdIX6E3dp1w==
Date: Tue, 25 Jun 2013 15:28:34 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP13l7ScDDf78MLK4vGsOm8XXnw4W
	j/resjswe+ycdZfd48SM3ywenzfJBTBHcdmkpOZklqUW6dslcGXsnv+SsaDdvuLInNOMDYwr
	zbsYOTkkBEwkTqzfxAphi0lcuLeeDcQWEljGKNE8R7WLkQvI7mWSmLHmJytEYj6jxOLl9iA2
	m4C6xOfXO9hBbBEBI4nPL66wgjQwC/QxSrR3TwRKcHAIC0hLvDwkA1EjIzGz9SMrhK0ncerf
	OTCbRUBV4u+XLUwgNq+AvcTd10uYQVqFBAIklk8qAAkzAt32/dQasBJmAXGJ5tabLBA3C0gs
	2XOeGcIWlXj5+B8rSKuEgKLE9tVWEOVaEut3Hodq1ZZ48u4CK8QmQYkfk++xTGAUm4Vk6iwk
	LbOQtMxC0rKAkWUVo1hpcXJBcVJ6aoWhXnFibnFpXrpecn7uJkZINFXtYLzz1eYQowAHoxIP
	r8LWk4FCrIllxZW5hxglOJiVRHgPZQGFeFMSK6tSi/Lji0pzUosPMTJxcEo1MJr+uah9vEB7
	e3blQXON+0JdPw44qP0KPXyJ+3n+/m3f5GxCuOO1tj95LacqcW6tDJPbpU3ZtSr+jKFuX/6e
	X7XB7jd3kPxis+uXtykfL7vtq+vHyLj06rYblnFn5/7ep7un9e/1R8Y/S+95Wl3dZ27hx3Lr
	/P3T3dynTHJuq7y0eGJzbuP8IHklluKMREMt5qLiRADbTPb2hAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 09:27 AM, Linus Torvalds wrote:
> So this is hopefully the last -rc in the series, and things have
> indeed be calming down finally, so assuming that trend continues,
> we're all good.
>
> Which means that we still want more testing and people hollering if
> there are any regressions etc.
>
> rc7 contains a fairly mixed collection of fixes all over, with (as
> usual) drivers and some arch updates being most noticeable.  This time
> we had media updates in particular.
>
> But there's also core fixes for things like fallout from the common
> cpu-idle routines and some timer accounting for the new full-NOHZ
> modes etc. So we have stuff all over, most of it happily fairly small.
>
> Go test,
>
>                  Linus
>
> ---

I started seeing this message during suspend to disk in reboot mode test 
back 3.10-rc6 and 3.10-rc7 has the same problem. I haven't started 
debugging yet. Looking to see if this is a known issue. I don't see this 
problem on 3.9.7.

[ 2097.548150] WARNING: at drivers/gpu/drm/i915/intel_display.c:1656 
ironlake_crtc_disable+0x865/0x890 [i915]()
[ 2097.548177] Modules linked in: rfcomm bnep parport_pc ppdev arc4 
iwldvm mac80211 ext2 i915 joydev coretemp kvm_intel snd_hda_codec_hdmi 
iwlwifi snd_hda_codec_realtek kvm snd_hda_intel snd_hda_codec cfg80211 
snd_hwdep snd_pcm drm_kms_helper btusb snd_seq_midi bluetooth drm 
snd_rawmidi uvcvideo snd_seq_midi_event ghash_clmulni_intel snd_seq 
aesni_intel ablk_helper videobuf2_core cryptd tpm_infineon videodev 
snd_timer lrw gf128mul snd_seq_device glue_helper psmouse snd aes_x86_64 
media samsung_laptop videobuf2_vmalloc microcode videobuf2_memops 
serio_raw soundcore tpm_tis snd_page_alloc i2c_algo_bit lpc_ich wmi 
video mac_hid lp parport hid_generic usbhid hid r8169
[ 2097.548180] CPU: 3 PID: 2736 Comm: kworker/u16:0 Not tainted 
3.10.0-rc7+ #2
[ 2097.548181] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
[ 2097.548186] Workqueue: events_unbound async_run_entry_fn
[ 2097.548189]  0000000000000009 ffff8803f05a5a58 ffffffff81690b04 
ffff8803f05a5a98
[ 2097.548190]  ffffffff81043880 ffff88040a978000 ffff8803f074e000 
ffff88040a978000
[ 2097.548192]  ffff88040a97a688 00000000000e0300 ffff88040af6e000 
ffff8803f05a5aa8
[ 2097.548192] Call Trace:
[ 2097.548197]  [<ffffffff81690b04>] dump_stack+0x19/0x1b
[ 2097.548201]  [<ffffffff81043880>] warn_slowpath_common+0x70/0xa0
[ 2097.548203]  [<ffffffff810438ca>] warn_slowpath_null+0x1a/0x20
[ 2097.548214]  [<ffffffffa0428f35>] ironlake_crtc_disable+0x865/0x890 
[i915]
[ 2097.548223]  [<ffffffffa042a408>] __intel_set_mode+0x458/0xd00 [i915]
[ 2097.548232]  [<ffffffffa04345d9>] 
intel_modeset_setup_hw_state+0x679/0xa60 [i915]
[ 2097.548236]  [<ffffffff8169404d>] ? mutex_lock+0x1d/0x50
[ 2097.548242]  [<ffffffffa03ff277>] __i915_drm_thaw+0x137/0x1d0 [i915]
[ 2097.548249]  [<ffffffffa03ff5cb>] i915_resume+0x7b/0xd0 [i915]
[ 2097.548255]  [<ffffffffa03ff636>] i915_pm_resume+0x16/0x20 [i915]
[ 2097.548258]  [<ffffffff81355463>] pci_pm_restore+0x73/0xd0
[ 2097.548259]  [<ffffffff813553f0>] ? pci_pm_default_resume+0x50/0x50
[ 2097.548261]  [<ffffffff813553f0>] ? pci_pm_default_resume+0x50/0x50
[ 2097.548264]  [<ffffffff81424f9b>] dpm_run_callback.isra.3+0x3b/0x70
[ 2097.548265]  [<ffffffff81425824>] device_resume+0xd4/0x1b0
[ 2097.548267]  [<ffffffff81425921>] async_resume+0x21/0x50
[ 2097.548269]  [<ffffffff8107001b>] async_run_entry_fn+0x3b/0x140
[ 2097.548272]  [<ffffffff810626ae>] process_one_work+0x16e/0x3f0
[ 2097.548274]  [<ffffffff81062dc2>] worker_thread+0x122/0x370
[ 2097.548276]  [<ffffffff81062ca0>] ? rescuer_thread+0x330/0x330
[ 2097.548277]  [<ffffffff810695e0>] kthread+0xc0/0xd0
[ 2097.548279]  [<ffffffff81069520>] ? kthread_create_on_node+0x130/0x130
[ 2097.548281]  [<ffffffff8169f81c>] ret_from_fork+0x7c/0xb0
[ 2097.548283]  [<ffffffff81069520>] ? kthread_create_on_node+0x130/0x130
[ 2097.548284] ---[ end trace 989c661118e428a8 ]---

[ 2097.548295] WARNING: at drivers/gpu/drm/i915/intel_display.c:1091 
assert_pch_pll+0x18f/0x1f0 [i915]()
[ 2097.548296] PCH PLL state for reg c6014 assertion failure (expected 
off, current on), val=89086008
[ 2097.548315] Modules linked in: rfcomm bnep parport_pc ppdev arc4 
iwldvm mac80211 ext2 i915 joydev coretemp kvm_intel snd_hda_codec_hdmi 
iwlwifi snd_hda_codec_realtek kvm snd_hda_intel snd_hda_codec cfg80211 
snd_hwdep snd_pcm drm_kms_helper btusb snd_seq_midi bluetooth drm 
snd_rawmidi uvcvideo snd_seq_midi_event ghash_clmulni_intel snd_seq 
aesni_intel ablk_helper videobuf2_core cryptd tpm_infineon videodev 
snd_timer lrw gf128mul snd_seq_device glue_helper psmouse snd aes_x86_64 
media samsung_laptop videobuf2_vmalloc microcode videobuf2_memops 
serio_raw soundcore tpm_tis snd_page_alloc i2c_algo_bit lpc_ich wmi 
video mac_hid lp parport hid_generic usbhid hid r8169
[ 2097.548317] CPU: 3 PID: 2736 Comm: kworker/u16:0 Tainted: G        W 
    3.10.0-rc7+ #2
[ 2097.548318] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
[ 2097.548321] Workqueue: events_unbound async_run_entry_fn
[ 2097.548323]  0000000000000009 ffff8803f05a59b8 ffffffff81690b04 
ffff8803f05a59f8
[ 2097.548324]  ffffffff81043880 0000000000000009 ffff88040a978000 
ffff88040a97a688
[ 2097.548325]  0000000000000000 0000000000000000 0000000089086008 
ffff8803f05a5a58
[ 2097.548326] Call Trace:
[ 2097.548328]  [<ffffffff81690b04>] dump_stack+0x19/0x1b
[ 2097.548330]  [<ffffffff81043880>] warn_slowpath_common+0x70/0xa0
[ 2097.548332]  [<ffffffff81043966>] warn_slowpath_fmt+0x46/0x50
[ 2097.548360]  [<ffffffffa042436f>] assert_pch_pll+0x18f/0x1f0 [i915]
[ 2097.548382]  [<ffffffffa0428c79>] ironlake_crtc_disable+0x5a9/0x890 
[i915]
[ 2097.548404]  [<ffffffffa042a408>] __intel_set_mode+0x458/0xd00 [i915]
[ 2097.548429]  [<ffffffffa04345d9>] 
intel_modeset_setup_hw_state+0x679/0xa60 [i915]
[ 2097.548438]  [<ffffffff8169404d>] ? mutex_lock+0x1d/0x50
[ 2097.548454]  [<ffffffffa03ff277>] __i915_drm_thaw+0x137/0x1d0 [i915]
[ 2097.548472]  [<ffffffffa03ff5cb>] i915_resume+0x7b/0xd0 [i915]
[ 2097.548490]  [<ffffffffa03ff636>] i915_pm_resume+0x16/0x20 [i915]
[ 2097.548496]  [<ffffffff81355463>] pci_pm_restore+0x73/0xd0
[ 2097.548500]  [<ffffffff813553f0>] ? pci_pm_default_resume+0x50/0x50
[ 2097.548504]  [<ffffffff813553f0>] ? pci_pm_default_resume+0x50/0x50
[ 2097.548509]  [<ffffffff81424f9b>] dpm_run_callback.isra.3+0x3b/0x70
[ 2097.548513]  [<ffffffff81425824>] device_resume+0xd4/0x1b0
[ 2097.548517]  [<ffffffff81425921>] async_resume+0x21/0x50
[ 2097.548524]  [<ffffffff8107001b>] async_run_entry_fn+0x3b/0x140
[ 2097.548529]  [<ffffffff810626ae>] process_one_work+0x16e/0x3f0
[ 2097.548534]  [<ffffffff81062dc2>] worker_thread+0x122/0x370
[ 2097.548540]  [<ffffffff81062ca0>] ? rescuer_thread+0x330/0x330
[ 2097.548544]  [<ffffffff810695e0>] kthread+0xc0/0xd0
[ 2097.548549]  [<ffffffff81069520>] ? kthread_create_on_node+0x130/0x130
[ 2097.548553]  [<ffffffff8169f81c>] ret_from_fork+0x7c/0xb0
[ 2097.548558]  [<ffffffff81069520>] ? kthread_create_on_node+0x130/0x130
[ 2097.548560] ---[ end trace 989c661118e428a9 ]---

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
