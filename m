Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbaDBHq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:46:56 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34594 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035AbaDBHqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:46:54 -0400
Date: Wed, 2 Apr 2014 09:46:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86,mm: delay TLB flush after clearing accessed bit
Message-ID: <20140402074651.GA22772@gmail.com>
References: <20140331113442.0d628362@annuminas.surriel.com>
 <CA+55aFzG=B3t_YaoCY_H1jmEgs+cYd--ZHz7XhGeforMRvNfEQ@mail.gmail.com>
 <533AE518.1090705@redhat.com>
 <CA+55aFx9KYTV_N3qjV6S9uu6iTiVZimXhZtUa9UYRkNR9P-7RQ@mail.gmail.com>
 <533B0603.7040301@redhat.com>
 <20140402060601.GA31305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402060601.GA31305@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shli@kernel.org> wrote:

> On Tue, Apr 01, 2014 at 02:31:31PM -0400, Rik van Riel wrote:
> > On 04/01/2014 12:21 PM, Linus Torvalds wrote:
> > > On Tue, Apr 1, 2014 at 9:11 AM, Rik van Riel <riel@redhat.com> wrote:
> > >>
> > >> Memory pressure is not necessarily caused by the same process
> > >> whose accessed bit we just cleared. Memory pressure may not
> > >> even be caused by any process's virtual memory at all, but it
> > >> could be caused by the page cache.
> > > 
> > > If we have that much memory pressure on the page cache without having
> > > any memory pressure on the actual VM space, then the swap-out activity
> > > will never be an issue anyway.
> > > 
> > > IOW, I think all these scenarios are made-up. I'd much rather go for
> > > simpler implementation, and make things more complex only in the
> > > presence of numbers. Of which we have none.
> > 
> > We've been bitten by the lack of a properly tracked accessed
> > bit before, but admittedly that was with the KVM code and EPT.
> > 
> > I'll add my Acked-by: to Shaohua's original patch then, and
> > will keep my eyes open for any problems that may or may not
> > materialize...
> > 
> > Shaohua?
> 
> I'd agree to choose the simple implementation at current stage and check if
> there are problems really.
> 
> Andrew,
> can you please pick up my orginal patch "x86: clearing access bit don't
> flush tlb" (with Rik's Ack)? Or I can resend it if you preferred.

Please resend it so I can pick it up for this cycle, that approach 
obviously looks good.

Thanks,

	Ingo
