Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaDPWTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:19:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54095 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbaDPWTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:19:02 -0400
Message-ID: <534F01D1.9000206@gmail.com>
Date: Thu, 17 Apr 2014 00:18:57 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: debug_dma_assert_idle - snd_hda_intel - cpu touching an active dma
 mapped cacheline
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sound whispers,

 WARNING: CPU: 3 PID: 900 at lib/dma-debug.c:593
debug_dma_assert_idle+0x159/0x1d0()
 snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped
cacheline [cln=0x03014000]
 CPU: 3 PID: 900 Comm: chronyd Not tainted 3.15.0-0.rc1.git1.1.fc21.i686 #1
 Call Trace:
  [<c0ae256d>] dump_stack+0x48/0x60
  [<c0454402>] warn_slowpath_common+0x82/0xa0
  [<c0750b69>] ? debug_dma_assert_idle+0x159/0x1d0
  [<c0750b69>] ? debug_dma_assert_idle+0x159/0x1d0
  [<c045445e>] warn_slowpath_fmt+0x3e/0x60
  [<c0750b69>] debug_dma_assert_idle+0x159/0x1d0
  [<c05860b9>] ? anon_vma_prepare+0x29/0x140
  [<c057a4ee>] do_wp_page+0xce/0x890
  [<c0500045>] ? auditsc_get_stamp+0x45/0x70
  [<c057caf2>] handle_mm_fault+0x662/0xb70
  [<c0500045>] ? auditsc_get_stamp+0x45/0x70
  [<c0aee507>] __do_page_fault+0x1a7/0x5d0
  [<c040ace8>] ? sched_clock+0x8/0x10
  [<c040ace8>] ? sched_clock+0x8/0x10
  [<c04ab036>] ? lock_release_holdtime.part.28+0x96/0xf0
  [<c0aee930>] ? __do_page_fault+0x5d0/0x5d0
  [<c0aee94a>] do_page_fault+0x1a/0x20
  [<c0aeb344>] error_code+0x6c/0x74
  [<c07334b6>] ? __put_user_4+0x1a/0x24
  [<c048d280>] ? schedule_tail+0x60/0xa0
  [<c0af3746>] ret_from_fork+0x6/0x20
 ---[ end trace d31d73481e988403 ]---
 Mapped at:
  [<c074ec12>] debug_dma_alloc_coherent+0x22/0x70
  [<f812de90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
  [<f812dfe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
  [<f812e3b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
  [<f812df23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]


https://bugzilla.redhat.com/show_bug.cgi?id=1087565


poma

