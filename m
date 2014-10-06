Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaJFRZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbaJFRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:25:10 -0400
Date: Mon, 6 Oct 2014 19:24:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mike Hommey <mh@glandium.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 08/17] mm: madvise MADV_USERFAULT
Message-ID: <20141006172415.GC31075@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-9-git-send-email-aarcange@redhat.com>
 <20141003231336.GA13528@glandium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003231336.GA13528@glandium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 04, 2014 at 08:13:36AM +0900, Mike Hommey wrote:
> On Fri, Oct 03, 2014 at 07:07:58PM +0200, Andrea Arcangeli wrote:
> > MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
> > vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
> > userland touches a still unmapped virtual address, a sigbus signal is
> > sent instead of allocating a new page. The sigbus signal handler will
> > then resolve the page fault in userland by calling the
> > remap_anon_pages syscall.
> 
> What does "unmapped virtual address" mean in this context?

To clarify this I added this in a second sentence in the commit
header:

"still unmapped virtual address" of the previous sentence in this
context means that the pte/trans_huge_pmd is null. It means it's an
hole inside the anonymous vma (the kind of hole that doesn't account
for RSS but only virtual size of the process). It is the same state
all anonymous virtual memory is, right after mmap. The same state that
if you read from it, will map a zeropage into the faulting virtual
address. If the page is swapped out, it will not trigger userfaults.

If something isn't clear let me know.

Thanks,
Andrea
