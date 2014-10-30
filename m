Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161284AbaJ3RoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:44:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161264AbaJ3Rn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:43:58 -0400
Date: Thu, 30 Oct 2014 18:43:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 2/5] mm: gup: add __get_user_pages_unlocked to customize
 gup_flags
Message-ID: <20141030174309.GL19606@redhat.com>
References: <1414600520-7664-1-git-send-email-aarcange@redhat.com>
 <1414600520-7664-3-git-send-email-aarcange@redhat.com>
 <20141030121737.GB31134@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030121737.GB31134@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 02:17:37PM +0200, Kirill A. Shutemov wrote:
> On Wed, Oct 29, 2014 at 05:35:17PM +0100, Andrea Arcangeli wrote:
> > diff --git a/mm/gup.c b/mm/gup.c
> > index a8521f1..01534ff 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -591,9 +591,9 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
> >  						int write, int force,
> >  						struct page **pages,
> >  						struct vm_area_struct **vmas,
> > -						int *locked, bool notify_drop)
> > +						int *locked, bool notify_drop,
> > +						unsigned int flags)
> 
> Argument list getting too long. Should we consider packing them into a
> struct?

It's __always_inline, so it's certainly not a runtime concern. The
whole point of using __always_inline is to optimize away certain
branches at build time.

If this about cleaning it up and not for changing the runtime (which I
think couldn't get any better because of the __always_inline), we
should at least make certain gcc can still see through the structure
offsets to delete the same code blocks at build time if possible,
before doing the change.
