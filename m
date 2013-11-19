Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3KSIZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:25:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KSIZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:25:57 -0500
Date: Tue, 19 Nov 2013 09:25:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119082548.GD10022@twins.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
 <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
 <20131119104438.6d45828b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119104438.6d45828b@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:44:38AM +1100, NeilBrown wrote:
> We have loops that have
>     timeout = schedule_timeout(timeout)
> in the middle and if we change the semantics of schedule_timeout() to round
> up, those loops could wait quite a bit longer than expected.

Depends on what you expect; most of these functions have documentation
that says they will sleep at least timeout amount of time.

schedule_timeout()'s version looks like:

 * Make the current task sleep until @timeout jiffies have
 * elapsed.

Clearly it doesn't do that currently, so adding 1 will actually make it
do what it says on the tin.
