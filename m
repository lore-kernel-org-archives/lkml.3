Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaLCOUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:20:31 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:42915 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaLCOU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:20:28 -0500
Message-ID: <1417616416.10198.12.camel@lnxlarper.se.axis.com>
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
From: Lars Persson <lars.persson@axis.com>
To: Ralf Baechle <ralf@linux-mips.org>
CC: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paul.burton@imgtec.com" <paul.burton@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "markos.chandras@imgtec.com" <markos.chandras@imgtec.com>
Date: Wed, 3 Dec 2014 15:20:16 +0100
In-Reply-To: <20141203134226.GC16063@linux-mips.org>
References: <20141203032542.15388.17340.stgit@linux-yegoshin>
	 <1417599104.10996.16.camel@lnxlarper.se.axis.com>
	 <20141203134226.GC16063@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf

I remember now that we have applied to our tree the proposed patch
titled "MIPS HIGHMEM fixes for cache aliasing and non-DMA I/O".

This patch changes the semantics of flush_dcache_page() by using
page_mapped() instead of mapping_mapped() to decide if the flush should
be lazy. Is it this change that makes us get lazy flushes for code
mappings and therefore exposing the problem ? The ARM port which has
made a similar change to set_pte_at() also uses page_mapped() to decide
if lazy flushing is possible.

If this is true, then upstream might not need my patch. 

- Lars



On ons, 2014-12-03 at 14:42 +0100, Ralf Baechle wrote:
> Lars,
> 
> normally set_pte_at() is invoked in a 
> 
>   cache_flush_*()
>   set_pte_at()
>   tlb_flush_*()
> 
> sequence.  So I'm wondering if you're trying to fix something in set_pte_at
> that actually ought to be fixed in the cache_flush_*() function.
> 
> I'm wondering, have you identified which cache flush function in particular
> was used in the sequence in your particular bug's case?
> 
>   Ralf



