Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3G3L7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:59:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46316 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3G3L7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:59:14 -0400
Date: Tue, 30 Jul 2013 13:59:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
Message-ID: <20130730115905.GS3008@twins.programming.kicks-ass.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
 <20130730093519.GP3008@twins.programming.kicks-ass.net>
 <CABawtvNVeHbe06tbuH6Khgp_5gYmRYtk=sz9U7oE8f_x+6yg1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvNVeHbe06tbuH6Khgp_5gYmRYtk=sz9U7oE8f_x+6yg1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 07:44:03PM +0800, Ethan Zhao wrote:
> Got it.
> what tglx and you mean
> 
> 
> So the expensive thing maybe not inside the schedule(), but could
> outside the scheduler(), the more bigger forever loop.
> 
> This is one part of what I am facing.

Right, so it would be good if you could further diagnose the problem so
we can come up with a solution that cures the problem while retaining
the current 'desired' properties.

The patch you pinpointed caused a regression in that it would wake from
NOHZ mode far too often. Could it be that the now longer idle sections
cause your CPU to go into deeper idle modes and you're suffering from
idle-exit latencies?
