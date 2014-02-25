Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBYL4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:56:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39483 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaBYL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:56:15 -0500
Date: Tue, 25 Feb 2014 12:56:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: Re: [RFC patch 1/5] hrtimer: Always check for HRTIMER_MODE_REL
Message-ID: <20140225115607.GQ9987@twins.programming.kicks-ass.net>
References: <20140221173936.583477951@linutronix.de>
 <20140221174639.461201411@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221174639.461201411@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:56:15PM -0000, Thomas Gleixner wrote:
> We have not just HRTIMER_MODE_REL and HRTIMER_MODE_ABS, so a direct
> check for mode == HRTIMER_MODE_ABS is not sufficient.
> 
> Always check for the HRTIMER_MODE_REL bit.

This seems to come from having changed hrtimer_mode from a value field
to a bit field with the addition of PINNED.

But yeah; this certainly fixes these two sites. Ideally we'd to
something better to avoid making the same mistake again later. But the
only thing I can come up with is lots of work.

Acked-by: Peter Zijlstra <peterz@infradead.org>
