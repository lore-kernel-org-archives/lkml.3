Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaDWFdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:33:20 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34416 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaDWFdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:33:18 -0400
Message-ID: <53575099.1030501@gmail.com>
Date: Wed, 23 Apr 2014 07:33:13 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
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
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com>
In-Reply-To: <53570F1F.1000709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.04.2014 02:53, poma wrote:
> 
> This one comes and goes...
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 521 at lib/dma-debug.c:593
> debug_dma_assert_idle+0x159/0x1d0()
> snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped
> cacheline [cln=0x03019000]
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 927 at lib/dma-debug.c:593
> debug_dma_assert_idle+0x159/0x1d0()
> snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped
> cacheline [cln=0x03019000]
> 
> CPU: 3 PID: 927 Comm: firewalld Not tainted 3.15.0-0.rc2.git1.1.fc21.i686 #1
> 
> Call Trace:
> 
>  [<c0ae29dd>] dump_stack+0x48/0x60
> 
>  [<c0454402>] warn_slowpath_common+0x82/0xa0
> 
>  [<c0750e09>] ? debug_dma_assert_idle+0x159/0x1d0
> 
>  [<c0750e09>] ? debug_dma_assert_idle+0x159/0x1d0
> 
>  [<c045445e>] warn_slowpath_fmt+0x3e/0x60
> 
>  [<c0750e09>] debug_dma_assert_idle+0x159/0x1d0
> 
>  [<c0586189>] ? anon_vma_prepare+0x29/0x140
> 
>  [<c057a5be>] do_wp_page+0xce/0x890
> 
>  [<c0640065>] ? ext4_releasepage+0x95/0x130
> 
>  [<c057cbc2>] handle_mm_fault+0x662/0xb70
> 
>  [<c0640065>] ? ext4_releasepage+0x95/0x130
> 
>  [<c0aee997>] __do_page_fault+0x1a7/0x5d0
> 
>  [<c04adcac>] ? trace_hardirqs_on_caller+0x13c/0x1e0
> 
>  [<c04ff83c>] ? __audit_syscall_entry+0x8c/0xe0
> 
>  [<c04add5b>] ? trace_hardirqs_on+0xb/0x10
> 
>  [<c04adcac>] ? trace_hardirqs_on_caller+0x13c/0x1e0
> 
>  [<c04adcac>] ? trace_hardirqs_on_caller+0x13c/0x1e0
> 
>  [<c0aeedc0>] ? __do_page_fault+0x5d0/0x5d0
> 
>  [<c0aeedda>] do_page_fault+0x1a/0x20
> 
>  [<c0aeb7b4>] error_code+0x6c/0x74
> ---[ end trace 0464944e27da06b8 ]---
> Mapped at:
> 
> [<c074eeb2>] debug_dma_alloc_coherent+0x22/0x70
> 
> [<f839de90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
> 
> [<f839dfe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
> 
> [<f839e3b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
> 
> [<f839df23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]
> CPU: 2 PID: 521 Comm: firewalld Tainted: G        W
> 3.15.0-0.rc2.git1.1.fc21.i686 #1
> Call Trace:
>  [<c0ae29dd>] dump_stack+0x48/0x60
>  [<c0454402>] warn_slowpath_common+0x82/0xa0
>  [<c0750e09>] ? debug_dma_assert_idle+0x159/0x1d0
>  [<c0750e09>] ? debug_dma_assert_idle+0x159/0x1d0
>  [<c045445e>] warn_slowpath_fmt+0x3e/0x60
>  [<c0750e09>] debug_dma_assert_idle+0x159/0x1d0
>  [<c0586189>] ? anon_vma_prepare+0x29/0x140
>  [<c057a5be>] do_wp_page+0xce/0x890
>  [<c0640065>] ? ext4_releasepage+0x95/0x130
>  [<c057cbc2>] handle_mm_fault+0x662/0xb70
>  [<c0640065>] ? ext4_releasepage+0x95/0x130
>  [<c0aee997>] __do_page_fault+0x1a7/0x5d0
>  [<c04ff83c>] ? __audit_syscall_entry+0x8c/0xe0
>  [<c04add5b>] ? trace_hardirqs_on+0xb/0x10
>  [<c04adcac>] ? trace_hardirqs_on_caller+0x13c/0x1e0
>  [<c0aeedc0>] ? __do_page_fault+0x5d0/0x5d0
>  [<c0aeedda>] do_page_fault+0x1a/0x20
>  [<c0aeb7b4>] error_code+0x6c/0x74
> ---[ end trace 0464944e27da06b9 ]---
> Mapped at:
>  [<c074eeb2>] debug_dma_alloc_coherent+0x22/0x70
>  [<f839de90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
>  [<f839dfe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
>  [<f839e3b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
>  [<f839df23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]
> 
> 
> https://bugzilla.redhat.com/attachment.cgi?id=888686
> 
> dma debug: account for cachelines and read-only mappings in overlap tracking
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/lib/dma-debug.c?id=3b7a6418c7494b8bf0bf0537ddee1dedbca10f51
> 
> Are these two in some relation?

Yep.

3.15.0-0.rc2.git1.1.fc21.x86_64  PASSED
3.15.0-0.rc2.git1.1.fc21.i686    FAILED
3.15.0-0.rc2.git1.2.fc21.i686    PASSED <-

3.15.0-0.rc2.git1.2.fc21.i686 is
3.15.0-0.rc2.git1.1.fc21.i686 with reverted linux-next git commit 3b7a641
"dma debug: account for cachelines and read-only mappings in overlap
tracking"
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/lib/dma-debug.c?id=3b7a641


Information for build kernel-3.15.0-0.rc2.git1.1.fc21
http://koji.fedoraproject.org/koji/buildinfo?buildID=512446


poma

