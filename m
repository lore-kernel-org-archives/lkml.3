Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaJFI5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaJFI4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:56:51 -0400
Date: Mon, 6 Oct 2014 09:55:41 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
Message-ID: <20141006085540.GD2336@work-vm>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
 <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Fri, Oct 3, 2014 at 10:08 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > Overall this looks a fairly small change to the rmap code, notably
> > less intrusive than the nonlinear vmas created by remap_file_pages.
> 
> Considering that remap_file_pages() was an unmitigated disaster, and
> -mm has a patch to remove it entirely, I'm not at all convinced this
> is a good argument.
> 
> We thought remap_file_pages() was a good idea, and it really really
> really wasn't. Almost nobody used it, why would the anonymous page
> case be any different?

I've posted code that uses this interface to qemu-devel and it works nicely;
so chalk up at least one user.

For the postcopy case I'm using it for, we need to place a page, atomically
  some thread might try and access it, and must either
     1) get caught by userfault etc or
     2) must succeed in it's access

and we'll have that happening somewhere between thousands and millions of times
to pages in no particular order, so we need to avoid creating millions of mappings.

Dave



> 
>             Linus
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
