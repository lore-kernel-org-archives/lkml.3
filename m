Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab3BTTgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:36:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40393 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934027Ab3BTTgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:36:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: odd GPF bug on resume from hibernate.
Date: Wed, 20 Feb 2013 20:42:46 +0100
Message-ID: <11452407.3H88HXekKp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130220192826.GA3137@redhat.com>
References: <20130220192826.GA3137@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 02:28:26 PM Dave Jones wrote:
> We had two users report hitting a bug that looks like this..
> 
> general protection fault: 8800 [#1] SMP 
> PM: Restoring platform NVS memory
> Modules linked in: fuse ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq coretemp kvm_intel snd_seq_device kvm arc4 microcode snd_pcm rtl8192se serio_raw rtlwifi mac80211 i2c_i801 intel_ips jme lpc_ich mfd_core cfg80211 mii jmb38x_ms snd_page_alloc memstick snd_timer rfkill snd mei soundcore uinput hid_logitech_dj i915 crc32c_intel i2c_algo_bit drm_kms_helper sdhci_pci drm sdhci mmc_core i2c_core wmi video
> CPU 2 
> Pid: 0, comm: swapper/2 Not tainted 3.7.5-201.fc18.x86_64 #1 System76, Inc.                        Lemur UltraThin                      /Lemur UltraThin                      
> RIP: 0010:[<ffffffff81038335>]  [<ffffffff81038335>] read_apic_id+0x5/0x30
> RSP: 0018:ffff880131ea3ee8  EFLAGS: 00010046
> RAX: 0000000000000020 RBX: ffff880131ea2010 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
> RBP: ffff880131ea3ef8 R08: ffff880131ea2000 R09: ffff880131ea3ed0
> R10: ffff880131ea3ed4 R11: 0000000000000000 R12: 0000000000000020
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff880137d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f2f06237750 CR3: 0000000001c0b000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper/2 (pid: 0, threadinfo ffff880131ea2000, task ffff880131e9ae40)
> Stack:
>  ffff880131ea3fd8 ffffffff81cdc5d0 ffff880131ea3f28 ffffffff8101d508
>  ffff880131ea3f18 b9aafd27b651a356 0000000000000000 0000000000000000
>  ffff880131ea3f48 ffffffff816248dd 0000000000000000 e0e608b14cc4dccd
> Call Trace:
>  [<ffffffff8101d508>] cpu_idle+0x108/0x120
>  [<ffffffff816248dd>] start_secondary+0x23e/0x240
> Code: 25 40 3b 01 00 3c 03 76 07 0f 09 66 66 90 66 90 f4 eb fd 41 bc ff ff ff ff eb b1 0f 1f 00 0f 1f 84 00 00 00 00 00 48 8b 05 41 31 <ca> 00 55 bf 20 00 00 00 48 89 e5 ff 90 20 01 00 00 89 c7 48 8b 
> RIP  [<ffffffff81038335>] read_apic_id+0x5/0x30
>  RSP <ffff880131ea3ee8>
> 
> That Code: line translates to..
> 
>    0:	ca 00 55             	lret   $0x5500
> 
> At this point I don't know where to begin debugging..
> 
> Is that 8800 error code a clue ?

Does CPU offline/online work on this machine?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
