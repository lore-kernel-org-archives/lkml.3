Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaEKKC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:02:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37385 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbaEKKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:02:54 -0400
Message-ID: <536F4ACA.3040300@gmail.com>
Date: Sun, 11 May 2014 12:02:50 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Wei Liu <wei.liu2@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com> <5361D69E.1060802@gmail.com> <53684172.6090402@gmail.com> <536A0777.1050407@gmail.com>
In-Reply-To: <536A0777.1050407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


------------[ cut here ]------------
WARNING: CPU: 2 PID: 628 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03074000]
CPU: 2 PID: 628 Comm: lightdm Not tainted 3.15.0-0.rc5.git0.1.fc21.i686+debug #1
Call Trace:
 [<c0ae737d>] dump_stack+0x48/0x60
 [<c04547b2>] warn_slowpath_common+0x82/0xa0
 [<c0754d99>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c0754d99>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c045480e>] warn_slowpath_fmt+0x3e/0x60
 [<c0754d99>] debug_dma_assert_idle+0x159/0x1d0
 [<c058a149>] ? anon_vma_prepare+0x29/0x140
 [<c057e56e>] do_wp_page+0xce/0x890
 [<c0580b72>] handle_mm_fault+0x662/0xb70
 [<c0af3667>] __do_page_fault+0x1a7/0x5d0
 [<c04e1057>] ? SyS_futex+0x97/0x180
 [<c04b1b00>] ? trace_hardirqs_on_caller+0x1c0/0x1e0
 [<c04b1a7c>] ? trace_hardirqs_on_caller+0x13c/0x1e0
 [<c0af3a90>] ? __do_page_fault+0x5d0/0x5d0
 [<c0af3aaa>] do_page_fault+0x1a/0x20
 [<c0af0484>] error_code+0x6c/0x74
---[ end trace b400a64c04aed387 ]---
Mapped at:
 [<c0752e42>] debug_dma_alloc_coherent+0x22/0x70
 [<f80c3e90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
 [<f80c3fe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
 [<f80c43b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
 [<f80c3f23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]


poma


