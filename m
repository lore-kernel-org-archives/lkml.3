Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaDZShr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 14:37:47 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:47692 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751776AbaDZSho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 14:37:44 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2014 14:37:44 EDT
Message-ID: <535BFAF0.5090306@localhost>
Date: Sat, 26 Apr 2014 11:29:04 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
References: <20140411185739.GA6644@linutronix.de>
In-Reply-To: <20140411185739.GA6644@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:57 AM, Sebastian Andrzej Siewior wrote:
> Dear RT folks!
>
> I'm pleased to announce the v3.14-rt1 patch setty).
>
> Changes since v3.12.15-rt25
> - I dropped the sparc64 patches I had in the queue. They did not apply
>    cleanly, the code in v3.14 changed in the MMU area. Here is where I
>    remembered that it was not working perfectly either.

Saw this a moment ago (3.14.1 + rt1, Fedora 19 laptop - I think I have 
seen something similar in 3.12.x-r):

Apr 26 11:16:11 localhost kernel: [   96.323248] ------------[ cut here 
]------------
Apr 26 11:16:11 localhost kernel: [   96.323262] WARNING: CPU: 0 PID: 
2051 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
Apr 26 11:16:11 localhost kernel: [   96.323264] list_del corruption. 
prev->next should be ffff8802101196a0, but was 0000000000000001
Apr 26 11:16:11 localhost kernel: [   96.323266] Modules linked in: fuse 
ipt_MASQUERADE xt_CHECKSUM tun ip6t_rpfilter ip6t_REJECT xt_conntrack 
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables 
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
ip6table_mangle ip6table_security ip6table_raw rfcomm ip6table_filter 
bnep ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iTCO_wdt 
iTCO_vendor_support coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul 
crc32c_intel ghash_clmulni_intel uvcvideo videobuf2_vmalloc microcode 
videobuf2_memops snd_hda_codec_hdmi videobuf2_core videodev media 
serio_raw btusb bluetooth intel_ips i2c_i801 6lowpan_iphc 
snd_hda_codec_conexant snd_hda_codec_generic arc4 iwldvm mac80211 
iwlwifi lpc_ich sdhci_pci mfd_core sdhci cfg80211 mmc_core snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_timer 
ptp mei_me pps_core mei shpchp thinkpad_acpi snd ppdev soundcore rfkill 
parport_pc parport acpi_cpufreq uinput firewire_ohci nouveau 
firewire_core crc_itu_t i2c_algo_bit drm_kms_helper ttm drm mxm_wmi 
i2c_core wmi video
Apr 26 11:16:11 localhost kernel: [   96.323331] CPU: 0 PID: 2051 Comm: 
cinnamon Not tainted 3.14.1-200.rt1.1.fc19.ccrma.x86_64+rt #1
Apr 26 11:16:11 localhost kernel: [   96.323332] Hardware name: LENOVO 
4313CTO/4313CTO, BIOS 6MET64WW (1.27 ) 07/15/2010
Apr 26 11:16:11 localhost kernel: [   96.323334]  0000000000000000 
000000008a5c11dc ffff8800ae715a88 ffffffff81707fca
Apr 26 11:16:11 localhost kernel: [   96.323336]  ffff8800ae715ad0 
ffff8800ae715ac0 ffffffff8108d03d ffff8802101196a0
Apr 26 11:16:11 localhost kernel: [   96.323337]  ffff880210119b50 
ffff880210119b50 ffff880210119b40 ffff88021a615648
Apr 26 11:16:11 localhost kernel: [   96.323338] Call Trace:
Apr 26 11:16:11 localhost kernel: [   96.323345]  [<ffffffff81707fca>] 
dump_stack+0x4d/0x82
Apr 26 11:16:11 localhost kernel: [   96.323351]  [<ffffffff8108d03d>] 
warn_slowpath_common+0x7d/0xc0
Apr 26 11:16:11 localhost kernel: [   96.323352]  [<ffffffff8108d0dc>] 
warn_slowpath_fmt+0x5c/0x80
Apr 26 11:16:11 localhost kernel: [   96.323354]  [<ffffffff8137c551>] 
__list_del_entry+0xa1/0xd0
Apr 26 11:16:11 localhost kernel: [   96.323355]  [<ffffffff8137c58d>] 
list_del+0xd/0x30
Apr 26 11:16:11 localhost kernel: [   96.323393]  [<ffffffffa0135593>] 
nouveau_fence_signal+0x53/0x80 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323414]  [<ffffffffa0135678>] 
nouveau_fence_update+0x48/0xa0 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323435]  [<ffffffffa0135f85>] 
nouveau_fence_sync+0x45/0x80 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323456]  [<ffffffffa013aea8>] 
validate_list+0xd8/0x2e0 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323478]  [<ffffffffa013c3d3>] 
nouveau_gem_ioctl_pushbuf+0xaa3/0x13e0 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323500]  [<ffffffffa002ad02>] 
drm_ioctl+0x4f2/0x620 [drm]
Apr 26 11:16:11 localhost kernel: [   96.323506]  [<ffffffff810c1af4>] ? 
migrate_enable+0x94/0x1c0
Apr 26 11:16:11 localhost kernel: [   96.323527]  [<ffffffffa0132cfe>] 
nouveau_drm_ioctl+0x4e/0x90 [nouveau]
Apr 26 11:16:11 localhost kernel: [   96.323530]  [<ffffffff81203480>] 
do_vfs_ioctl+0x2e0/0x4c0
Apr 26 11:16:11 localhost kernel: [   96.323533]  [<ffffffff812fd8d6>] ? 
file_has_perm+0xa6/0xb0
Apr 26 11:16:11 localhost kernel: [   96.323535]  [<ffffffff812036e1>] 
SyS_ioctl+0x81/0xa0
Apr 26 11:16:11 localhost kernel: [   96.323538]  [<ffffffff81716769>] 
system_call_fastpath+0x16/0x1b
Apr 26 11:16:11 localhost kernel: [   96.323569] ---[ end trace 
0000000000000002 ]---

-- Fernando
