Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaELMYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:24:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaELMYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:24:54 -0400
Date: Mon, 12 May 2014 14:24:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
Message-ID: <20140512122452.GB13467@laptop.programming.kicks-ass.net>
References: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:09:58PM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
> 
> Looking at the code of sched_getparam() and sched_setscheduler() (to
> see what might need to land in the man pagea with respect to
> SCHED_DEADLINE changes), I see that the former fails (EINVAL) if the
> target is a SCHED_DEADLINE process, while the latter succeeds
> (returning SCHED_DEADLINE).
> 
> The sched_setscheduler() seems fine, but what's the rationale for
> having sched_getparam() fail in this case, rather than just returning
> a sched_priority of zero (since sched_priority is in any case unused,
> as for SCHED_OTHER, right)? My point is that the change seems to
> needlessly break applications that employ sched_getparam(). Maybe I am
> missing something...

s/setscheduler/getscheduler/ ?

I'm a proponent of fail hard instead of fail silently and muddle on.

And while we can fully and correctly return sched_getscheduler() we
cannot do so for sched_getparam().

Returning sched_param::sched_priority == 0 for DEADLINE would also break
the symmetry between sched_setparam() and sched_getparam(), both will
fail for SCHED_DEADLINE.


