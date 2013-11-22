Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3KVKzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:55:05 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:34162 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3KVKzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:55:03 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <alpine.DEB.2.00.1311221036020.16356@skynet.skynet.ie>
References: <1384980928.3312.6.camel@localhost.localdomain>
	<alpine.DEB.2.00.1311221036020.16356@skynet.skynet.ie>
Date: Fri, 22 Nov 2013 11:55:01 +0100
X-Google-Sender-Auth: LS_Jr5qvN5lfx4Ra2gNtW6GGsY8
Message-ID: <CAKMK7uGoAN=PHu+=1FmXPGyZxg3+Mm2awJgkOfO8zBDF2-5arQ@mail.gmail.com>
Subject: Re: [i915] BUG: Bad page state in process Xorg
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@linux.ie>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote:
>> Hi,
>
> cc'ing mailing list,
>
> Daniel any ideas?

Nope, not really :( And no ideas how to triage this further - if it
takes 9 days to hit it eventually we'll have a real hard time. Or does
this happen even after just a short X run?

Also is this a regression, i.e. please test a few older kernels, too.
-Daniel

>
> Dave.
>
>> I reported this bug a few days ago, but nobody did respond to my bug
>> report:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1311.2/00058.html
>>
>> Every time I restart the X server I will run into this bug with 3.12.0.
>>
>> Help is welcome.
>>
>> [ 9913.719551] BUG: Bad page state in process Xorg  pfn:20f2bb
>> [ 9913.721755] page:ffffea00083caec0 count:0 mapcount:0 mapping:ffff8802357975f8 index:0xe
>> [ 9913.733741] page flags: 0x800000000008001c(referenced|uptodate|dirty|swapbacked)
>> [ 9913.741062] Modules linked in: tcp_lp fuse ipt_MASQUERADE ip6t_REJECT xt_conntrack bluetooth ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 iwldvm snd_usb_audio mac80211 snd_hda_codec_hdmi iwlwifi snd_hda_codec_realtek snd_usbmidi_lib snd_hda_intel kvm_intel asix snd_hda_codec usbnet kvm atl1c snd_hwdep mii snd_seq acer_wmi acerhdf sparse_keymap snd_pcm joydev pcspkr cfg80211 rfkill acpi_cpufreq freq_table snd_rawmidi snd_seq_device snd_page_alloc snd_timer snd wmi soundcore uinput ipv6 xts gf128mul udl syscopyarea sysfillrect sysimgblt drm_usb usb_storage
>> [ 9913.741125] CPU: 0 PID: 723 Comm: Xorg Tainted: G    B        3.12.0 #2
>> [ 9913.741128] Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
>> [ 9913.741130]  0000000000000000 ffff880213127cc0 ffffffff8154dc8b ffff880213127cd8
>> [ 9913.741135]  ffffffff8154b6e7 ffffea00083caec0 ffff880213127d10 ffffffff810c6955
>> [ 9913.741139]  ffffea00083caec0 800000000008001c 0000000000000000 ffff880234080000
>> [ 9913.741143] Call Trace:
>> [ 9913.741151]  [<ffffffff8154dc8b>] dump_stack+0x19/0x1b
>> [ 9913.741155]  [<ffffffff8154b6e7>] bad_page+0xc9/0xe2
>> [ 9913.741160]  [<ffffffff810c6955>] free_pages_prepare+0xd5/0xe0
>> [ 9913.741165]  [<ffffffff810c725d>] free_hot_cold_page+0x1d/0x120
>> [ 9913.741169]  [<ffffffff810cbe9e>] __put_single_page+0x1e/0x30
>> [ 9913.741172]  [<ffffffff810cc045>] put_page+0x25/0x40
>> [ 9913.741178]  [<ffffffff81346a73>] i915_gem_object_put_pages_gtt+0xc3/0x1a0
>> [ 9913.741183]  [<ffffffff81348378>] i915_gem_object_put_pages+0x78/0xd0
>> [ 9913.741187]  [<ffffffff8134a167>] i915_gem_free_object+0xe7/0x220
>> [ 9913.741192]  [<ffffffff81318a75>] drm_gem_object_free+0x25/0x30
>> [ 9913.741196]  [<ffffffff8132e5db>] drm_gem_dmabuf_release+0x4b/0x70
>> [ 9913.741201]  [<ffffffff813ae0b7>] dma_buf_release+0x27/0x90
>> [ 9913.741205]  [<ffffffff8110deab>] __fput+0xcb/0x240
>> [ 9913.741209]  [<ffffffff8110e059>] ____fput+0x9/0x10
>> [ 9913.741214]  [<ffffffff81052b5c>] task_work_run+0x9c/0xc0
>> [ 9913.741219]  [<ffffffff8103a365>] do_exit+0x6d5/0x9d0
>> [ 9913.741223]  [<ffffffff81551063>] ? __schedule+0x243/0x5e0
>> [ 9913.741227]  [<ffffffff81052b44>] ? task_work_run+0x84/0xc0
>> [ 9913.741232]  [<ffffffff8103b4d5>] do_group_exit+0x35/0x90
>> [ 9913.741236]  [<ffffffff8103b53f>] SyS_exit_group+0xf/0x10
>> [ 9913.741241]  [<ffffffff81558960>] system_call_fastpath+0x16/0x1b
>> [ 9913.741246] BUG: Bad page state in process Xorg  pfn:20f2bc
>> [ 9913.749565] page:ffffea00083caf00 count:0 mapcount:0 mapping:ffff8802357975f8 index:0xf
>>
>> with kind regards
>> thomas
>>
>>
>>
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
