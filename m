Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJERP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:15:57 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35177 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaJERPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1410041947080.7055@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1410041947080.7055@chino.kir.corp.google.com>
Date: Sun, 5 Oct 2014 10:15:53 -0700
X-Google-Sender-Auth: kmVHEHeZoLufiU28oy3zZ5I1Crk
Message-ID: <CA+55aFx+n_n5wXBE7d+6cL-3ObUqNsJt7ZuuthOb+tmKZYeSyw@mail.gmail.com>
Subject: Re: [patch for-3.17] mm, thp: fix collapsing of hugepages on madvise
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suleiman Souhlal <suleiman@google.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2014 at 7:48 PM, David Rientjes <rientjes@google.com> wrote:
>
> This occurs because the madvise(2) handler for thp, hugepage_advise(),
> clears VM_NOHUGEPAGE on the stack and it isn't stored in vma->vm_flags
> until the final action of madvise_behavior().  This causes the
> khugepaged_enter_vma_merge() to be a no-op in hugepage_advise() when the
> vma had previously had VM_NOHUGEPAGE set.

So color me confused, and when I'm confused I don't apply patches. But
there's no "hugepage_advise()" in my source tree, and quite frankly, I
also don't like how you now separately pass in vm_flags that always
*should* be the same as vma->vm_flags.

Maybe this is against -mm, but it's marked for stable and sent to me,
so I'm piping up about my lack of applying this.

                Linus
