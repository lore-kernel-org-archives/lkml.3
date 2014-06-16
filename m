Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaFPW2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:28:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:33836 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaFPW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:28:06 -0400
Date: Tue, 17 Jun 2014 00:28:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <darren@dvhart.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: Re: [patch 1/5] futex: Make unlock_pi more robust
In-Reply-To: <alpine.DEB.2.10.1406170002050.5170@nanos>
Message-ID: <alpine.DEB.2.10.1406170025510.5170@nanos>
References: <20140611202744.676528190@linutronix.de>  <20140611204237.016987332@linutronix.de> <1402935528.15603.14.camel@rage> <alpine.DEB.2.10.1406170002050.5170@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Thomas Gleixner wrote:
> On Mon, 16 Jun 2014, Darren Hart wrote:
> > On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> > In wake_futex_pi we verify ownership by matching pi_state->owner ==
> > current, but here the only test is the TID value, which is set by
> > userspace - which we don't trust...
> > 
> > I'm trying to determine if it matters in this case... if there are no
> > waiters, is the pi_state still around? If so, it does indeed matter, and
> > we should be verifying.
> 
> Erm. The whole point of this patch is to do:
> 
>      - Find existing state first and handle it.
> 
>      - If no state exists and TID == current, take it
> 
>      - Otherwise create state

Duh, that was the lock path. But here the point is:

      - Find existing state first and handle it.

      - If no state exists and TID == current, release it

The retry is obvious, right?

Thanks,

	tglx

