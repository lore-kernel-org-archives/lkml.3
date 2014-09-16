Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaIPWoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:44:17 -0400
Received: from v.hpx.cz ([46.28.110.221]:57464 "EHLO v.hpx.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaIPWoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:44:16 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 18:44:15 EDT
Date: Wed, 17 Sep 2014 00:34:05 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
Message-ID: <20140916223402.GL15807@hpx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJu=L59f6ODMDOiKEGGSGg+0RhYw3FDy5D7AJcCOrHD5xL_iwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Emergency posting to fix the tag and couldn't find unmangled Cc list,
 so some recipients were dropped, sorry.  (I guess you are glad though).]

2014-09-16 14:01-0700, Andres Lagar-Cavilla:
> On Tue, Sep 16, 2014 at 1:51 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> > 2014-09-15 13:11-0700, Andres Lagar-Cavilla:
> >> +int kvm_get_user_page_retry(struct task_struct *tsk, struct
> >> mm_struct *mm,
> >
> > The suffix '_retry' is not best suited for this.
> > On first reading, I imagined we will be retrying something from
> > before,
> > possibly calling it in a loop, but we are actually doing the first and
> > last try in one call.
> 
> We are doing ... the second and third in most scenarios. async_pf did
> the first with _NOWAIT. We call this from the async pf retrier, or if
> async pf couldn't be notified to the guest.

I was thinking more about what the function does, not how we currently
use it -- nothing prevents us from using it as first somewhere -- but
yeah, even comments would be off then.

> >> Apart from this, the patch looks good.  The mm/ parts are minimal, so
> >> I
> >> think it's best to merge it through the KVM tree with someone's
> >> Acked-by.
> >
> > I would prefer to have the last hunk in a separate patch, but still,
> >
> > Acked-by: Radim Krčmář <rkrcmar@redhat.com>
> 
> Awesome, thanks much.
> 
> I'll recut with the VM_BUG_ON from Paolo and your Ack. LMK if anything
> else from this email should go into the recut.

Ah, sorry, I'm not maintaining mm ... what I meant was

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

and I had to leave before I could find a good apology for
VM_WARN_ON_ONCE(), so if you are replacing BUG_ON, you might want to
look at that one as well.
