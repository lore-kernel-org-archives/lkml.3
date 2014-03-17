Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbaCQSee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:34:34 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58895 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbaCQSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:34:31 -0400
Date: Mon, 17 Mar 2014 11:33:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Rafael Aquini <aquini@redhat.com>,
        Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: vmscan: do not swap anon pages just because free+file
 is low
In-Reply-To: <20140317151553.GG14688@cmpxchg.org>
Message-ID: <alpine.LSU.2.11.1403171131420.2475@eggly.anvils>
References: <1394811302-30468-1-git-send-email-hannes@cmpxchg.org> <53232901.5030307@redhat.com> <20140314170807.GW10663@suse.de> <alpine.LSU.2.11.1403152056430.21540@eggly.anvils> <20140317151553.GG14688@cmpxchg.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014, Johannes Weiner wrote:
> On Sat, Mar 15, 2014 at 09:20:16PM -0700, Hugh Dickins wrote:
> > 
> > Hannes, your patch looks reasonable to me, and as I read it would
> > be well complemented by Suleiman's and mine; but I do worry that
> > the "scan_balance = SCAN_ANON" block you're removing was inserted
> > for good reason, and its removal bring complaint from some direction.
> 
> It's been introduced with the original LRU split patch but there is no
> explanation why.  Rik's concern now was that the scan/rotate numbers
> might not be too meaningful with very little cache.
> 
> > By the way, I notice you marked yours for stable [3.12+]:
> > if it's for stable at all, shouldn't it be for 3.9+?
> > (well, maybe nobody's doing a 3.9.N.M but 3.10.N is still alive).
> 
> The code I'm removing is fairly old and it's only been reported to
> create problems starting with the fair zone allocator in 3.12.

Ah, you're right, thanks.

Hugh
