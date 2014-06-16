Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaFPWmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:42:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:39334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538AbaFPWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,489,1400050800"; 
   d="scan'208";a="529468328"
Message-ID: <1402958985.15603.49.camel@rage>
Subject: Re: [patch 1/5] futex: Make unlock_pi more robust
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 15:49:45 -0700
In-Reply-To: <alpine.DEB.2.10.1406170025510.5170@nanos>
References: <20140611202744.676528190@linutronix.de>
	  <20140611204237.016987332@linutronix.de> <1402935528.15603.14.camel@rage>
	 <alpine.DEB.2.10.1406170002050.5170@nanos>
	 <alpine.DEB.2.10.1406170025510.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 00:28 +0200, Thomas Gleixner wrote:
> On Tue, 17 Jun 2014, Thomas Gleixner wrote:
> > On Mon, 16 Jun 2014, Darren Hart wrote:
> > > On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> > > In wake_futex_pi we verify ownership by matching pi_state->owner ==
> > > current, but here the only test is the TID value, which is set by
> > > userspace - which we don't trust...
> > > 
> > > I'm trying to determine if it matters in this case... if there are no
> > > waiters, is the pi_state still around? If so, it does indeed matter, and
> > > we should be verifying.
> > 
> > Erm. The whole point of this patch is to do:
> > 
> >      - Find existing state first and handle it.
> > 
> >      - If no state exists and TID == current, take it
> > 
> >      - Otherwise create state
> 
> Duh, that was the lock path. But here the point is:
> 
>       - Find existing state first and handle it.
> 
>       - If no state exists and TID == current, release it
> 

Right, I understood your meaning, and I withdraw the concern.

> The retry is obvious, right?

Yes.

-- 
Darren Hart
Intel Open Source Technology Center


