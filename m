Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3KSAtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:49:08 -0500
Received: from tex.lwn.net ([70.33.254.29]:43991 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3KSAtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:49:04 -0500
Date: Mon, 18 Nov 2013 17:49:02 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131118174902.312d8fa6@lwn.net>
In-Reply-To: <20131118234209.GO16796@laptop.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
	<20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
	<20131118234209.GO16796@laptop.programming.kicks-ass.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 00:42:09 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> I briefly talked to Thomas about this earlier today and we need to fix
> this at a lower level -- the quick 'n dirty solution is to add 1 jiffy
> down in the timer-wheel when we enqueue these things.

That can lead to situations like the one I encountered years ago where
msleep(1) would snooze for 20ms.  I didn't get much love for my idea of
switching msleep() to hrtimers back then, but I still think it might be be
better to provide the resolution that the interface appears to promise.

jon
