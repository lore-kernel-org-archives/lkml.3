Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3FFVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:32:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3FFVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:32:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
Date: Thu, 06 Jun 2013 23:31:41 +0200
Message-ID: <10307835.fkACLi6FUD@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130523052547.13864.83306.stgit@localhost6.localdomain6>
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052547.13864.83306.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/OP5U+LFbE1UyXG0Tuic557hGGGIrntovwtUXnR0cT4
 DRQdn1pEimRlkhrMIV038RIr5f95lFvaXMn94G/RMDGpLNc8k7
 SkbQlpQk73WUA1KjOdjVnUpVY1xP+Ar3BUkkI/5tWdlQFkMxtx
 6cmpNZVkG9khOW1LvNF1EXj1r3z80YxfsP3vf2JhuIVECROm1A
 8ggK1HF3ddVjNxM3kboDNCoSv9+wiL4tXyXM1O0cluS9jeOK9S
 y+4UcXLMm9TewRbVjadANmuD1WL+5mTBSM399xqQbCiuuYdSU6
 IJu9FX2K04gED57QiHLXoH4k1XQ9l3VbMVHxhc311YvRxwfV5B
 H360S4gDDJHQ4qV2g/Ts=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 May 2013 14:25:48 HATAYAMA Daisuke wrote:
> This patch introduces mmap_vmcore().
> 
> Don't permit writable nor executable mapping even with mprotect()
> because this mmap() is aimed at reading crash dump memory.
> Non-writable mapping is also requirement of remap_pfn_range() when
> mapping linear pages on non-consecutive physical pages; see
> is_cow_mapping().
> 
> Set VM_MIXEDMAP flag to remap memory by remap_pfn_range and by
> remap_vmalloc_range_pertial at the same time for a single
> vma. do_munmap() can correctly clean partially remapped vma with two
> functions in abnormal case. See zap_pte_range(), vm_normal_page() and
> their comments for details.
> 
> On x86-32 PAE kernels, mmap() supports at most 16TB memory only. This
> limitation comes from the fact that the third argument of
> remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

I get build errors on 'make randconfig' from this, when building
NOMMU kernels on ARM. I suppose the new feature should be hidden
in #ifdef CONFIG_MMU.

	Arnd
