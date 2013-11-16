Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3KPOLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:11:11 -0500
Received: from www17.your-server.de ([213.133.104.17]:40936 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3KPOK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:10:59 -0500
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Nov 2013 09:10:59 EST
Subject: =?ISO-8859-1?Q?=20=1B[i915]?= BUG: Bad page state in process Xorg
From: Thomas Meyer <thomas@m3y3r.de>
Content-Type: text/plain; charset=utf-8
Message-Id: <0366E808-27DD-4ECB-8ACE-598CC0813313@m3y3r.de>
Date: Sat, 16 Nov 2013 14:46:47 +0100
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After 9 days uptime, I wanted to restart my Gnome-Session, but this fails because Xorg is hitting a kernel bug.

Xorg server isn't kill-able. I see these log entries:

[126489.697509] CPU: 0 PID: 690 Comm: Xorg Tainted: G    B        3.12.0+ #95
[126489.697511] Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
[126489.697513]  0000000000000000 ffff88009df21cd8 ffffffff81554512 ffff88009df21cf0
[126489.697517]  ffffffff81551f11 ffffea00022c5400 ffff88009df21d18 ffffffff810c549c
[126489.697520]  ffffea00022c5400 400000000008001c 0000000000000000 ffff88009df21d50
[126489.697524] Call Trace:
[126489.697529]  [<ffffffff81554512>] dump_stack+0x19/0x1b
[126489.697533]  [<ffffffff81551f11>] bad_page+0xc9/0xe2
[126489.697537]  [<ffffffff810c549c>] free_pages_prepare+0xac/0xc0
[126489.697541]  [<ffffffff810c5c7d>] free_hot_cold_page+0x1d/0x120
[126489.697545]  [<ffffffff810ca8fe>] __put_single_page+0x1e/0x30
[126489.697549]  [<ffffffff810caaa5>] put_page+0x25/0x40
[126489.697554]  [<ffffffff8134a133>] i915_gem_object_put_pages_gtt+0xc3/0x1a0
[126489.697558]  [<ffffffff8134ba68>] i915_gem_object_put_pages+0x78/0xd0
[126489.697562]  [<ffffffff8134d8b7>] i915_gem_free_object+0xe7/0x230
[126489.697566]  [<ffffffff8131bf25>] drm_gem_object_free+0x25/0x30
[126489.697570]  [<ffffffff81331b9b>] drm_gem_dmabuf_release+0x4b/0x70
[126489.697574]  [<ffffffff813b1e17>] dma_buf_release+0x27/0x90
[126489.697578]  [<ffffffff8110d41b>] __fput+0xcb/0x250
[126489.697582]  [<ffffffff8110d5d9>] ____fput+0x9/0x10
[126489.697586]  [<ffffffff81052e9c>] task_work_run+0x9c/0xc0
[126489.697590]  [<ffffffff8103a0f4>] do_exit+0x6f4/0xa00
[126489.697594]  [<ffffffff81052e84>] ? task_work_run+0x84/0xc0
[126489.697598]  [<ffffffff8103b301>] do_group_exit+0x31/0x90
[126489.697602]  [<ffffffff8103b36f>] SyS_exit_group+0xf/0x10
[126489.697606]  [<ffffffff8155f160>] system_call_fastpath+0x16/0x1b
[126489.697610] BUG: Bad page state in process Xorg  pfn:8b151
[126489.699837] page:ffffea00022c5440 count:0 mapcount:0 mapping:ffff88008cf63168 index:0x2b
[126489.702979] page flags: 0x400000000008001c(referenced|uptodate|dirty|swapbacked)
[126489.705295] Modules linked in: vfat fat ipt_MASQUERADE ip6t_REJECT xt_conntrack ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw tun tcp_lp loop fuse bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_usbmidi_lib snd_hwdep snd_seq arc4 snd_pcm iwldvm snd_page_alloc snd_rawmidi snd_seq_device snd_timer snd mac80211 kvm_intel soundcore kvm asix acer_wmi usbnet acerhdf mii sparse_keymap pcspkr joydev iwlwifi atl1c wmi cfg80211 rfkill acpi_cpufreq freq_table uinput ipv6 xts gf128mul usb_storage udl syscopyarea sysfillrect sysimgblt drm_usb [last unloaded: iptable_raw]

How to kill the Xorg server and restart gdm?

with kind regards
thomas