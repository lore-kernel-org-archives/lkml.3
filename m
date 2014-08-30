Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaH3Asf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 20:48:35 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53218 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaH3Asd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 20:48:33 -0400
Message-ID: <54011F5D.5040809@gmail.com>
Date: Sat, 30 Aug 2014 02:48:29 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Wei Liu <wei.liu2@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: debug_dma_assert_idle - ahci - cpu touching an active dma mapped
 cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com> <5361D69E.1060802@gmail.com> <53684172.6090402@gmail.com> <536A0777.1050407@gmail.com> <536F4ACA.3040300@gmail.com>
In-Reply-To: <536F4ACA.3040300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.2014 12:02, poma wrote:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 628 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
> snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03074000]
> CPU: 2 PID: 628 Comm: lightdm Not tainted 3.15.0-0.rc5.git0.1.fc21.i686+debug #1
> Call Trace:
>  [<c0ae737d>] dump_stack+0x48/0x60
>  [<c04547b2>] warn_slowpath_common+0x82/0xa0
>  [<c0754d99>] ? debug_dma_assert_idle+0x159/0x1d0
>  [<c0754d99>] ? debug_dma_assert_idle+0x159/0x1d0
>  [<c045480e>] warn_slowpath_fmt+0x3e/0x60
>  [<c0754d99>] debug_dma_assert_idle+0x159/0x1d0
>  [<c058a149>] ? anon_vma_prepare+0x29/0x140
>  [<c057e56e>] do_wp_page+0xce/0x890
>  [<c0580b72>] handle_mm_fault+0x662/0xb70
>  [<c0af3667>] __do_page_fault+0x1a7/0x5d0
>  [<c04e1057>] ? SyS_futex+0x97/0x180
>  [<c04b1b00>] ? trace_hardirqs_on_caller+0x1c0/0x1e0
>  [<c04b1a7c>] ? trace_hardirqs_on_caller+0x13c/0x1e0
>  [<c0af3a90>] ? __do_page_fault+0x5d0/0x5d0
>  [<c0af3aaa>] do_page_fault+0x1a/0x20
>  [<c0af0484>] error_code+0x6c/0x74
> ---[ end trace b400a64c04aed387 ]---
> Mapped at:
>  [<c0752e42>] debug_dma_alloc_coherent+0x22/0x70
>  [<f80c3e90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
>  [<f80c3fe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
>  [<f80c43b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
>  [<f80c3f23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]
> 

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1180 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
ahci 0000:00:09.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03001000]
Modules linked in: ip6t_rpfilter ip6t_REJECT xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw mt7601Usta(OE) nouveau kvm_amd ata_generic kvm uas pata_acpi ppdev mxm_wmi parport_serial video usb_storage k10temp r8169 i2c_algo_bit ttm drm_kms_helper serio_raw microcode parport_pc skge parport mii drm wmi i2c_nforce2 i2ccore pata_amd acpi_cpufreq sunrpc
CPU: 1 PID: 1180 Comm: gmain Tainted: G           OE  3.17.0-0.rc2.git3.1.fc22.i686 #1
...
Call Trace:
 [<c0b137d8>] dump_stack+0x48/0x60
 [<c0459092>] warn_slowpath_common+0x82/0xa0
 [<c076c1e9>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c076c1e9>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c04590ee>] warn_slowpath_fmt+0x3e/0x60
 [<c076c1e9>] debug_dma_assert_idle+0x159/0x1d0
 [<c059b8a9>] ? anon_vma_prepare+0x29/0x140
 [<c0590524>] do_wp_page+0xe4/0x8c0
 [<c0592722>] handle_mm_fault+0x662/0xba0
 [<c0447237>] ? __do_page_fault+0x1a7/0x5d0
 [<c0447298>] __do_page_fault+0x208/0x5d0
 [<c058ebd1>] ? might_fault+0x51/0xb0
 [<c058ec27>] ? might_fault+0xa7/0xb0
 [<c074dbb0>] ? _copy_to_user+0x40/0x60
 [<c0447660>] ? __do_page_fault+0x5d0/0x5d0
 [<c044767a>] do_page_fault+0x1a/0x20
 [<c0b1d2b4>] error_code+0x6c/0x74
---[ end trace d1e2e0e42481c1e4 ]---
Mapped at:
 [<c076a292>] debug_dma_alloc_coherent+0x22/0x70
 [<c0867cbb>] dmam_alloc_coherent+0xdb/0x130
 [<c08b798d>] ahci_port_start+0xed/0x230
 [<c089d23b>] ata_host_start.part.24+0xcb/0x1b0
 [<c08a2a35>] ata_host_activate+0x45/0x100

ahci:
00:09.0 SATA controller: NVIDIA Corporation MCP78S [GeForce 8200] AHCI Controller (rev a2)
and
snd_hda_intel:
00:07.0 Audio device: NVIDIA Corporation MCP72XE/MCP72P/MCP78U/MCP78S High Definition Audio (rev a1)
swapped the roles. :)
mt7601Usta is irrelevant as tainter, here.


poma



