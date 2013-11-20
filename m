Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3KTAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:09:27 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53931 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3KTAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:09:24 -0500
Date: Wed, 20 Nov 2013 01:09:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lockdep: Simplify a bit hardirq <-> softirq transitions
Message-ID: <20131120000919.GA15605@localhost.localdomain>
References: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 01:07:34AM +0100, Frederic Weisbecker wrote:
> Instead of saving the hardirq state on a per CPU variable, which require
> an explicit call before the softirq handling and some complication,
> just save and restore the hardirq tracing state through functions
> return values and parameters.
> 
> It simplifies a bit the black magic that works around the fact that
> softirqs can be called from hardirqs while hardirqs can nest on softirqs
> but those two cases have very different semantics and only the latter
> case assume both states.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

It applies on top of:

	"[tip:core/urgent] lockdep: Correctly annotate hardirq context in irq_exit()"

Thanks.
