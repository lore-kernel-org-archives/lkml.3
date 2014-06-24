Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaFXKm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:42:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaFXKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:42:23 -0400
Date: Tue, 24 Jun 2014 12:42:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Lu <zlu@tilera.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [BUG] perf: can not resolve symbols for forked threads
Message-ID: <20140624104213.GL19860@laptop.programming.kicks-ass.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D762567@USMAExch1.tad.internal.tilera.com>
 <20140623091243.GN19860@laptop.programming.kicks-ass.net>
 <BAB94DBB0E89D8409949BC28AC95914C5D76499C@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D76499C@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 06:47:38AM +0000, Tony Lu wrote:
> >That pthread_exit() is the problem; this results in:
> >
> >29456 pts/23   Zl     0:00          |               \_ [hello] <defunct>
> >
> >You want to wait for the threads to complete using pthread_join().
> >
> >I suspect the defunct state hides the process.
> 
> Yes, using pthread_join() can workaround this problem.
> Does that mean the parent thread can not exit before the child threads? It still seems like a perf bug.

So we scan /proc at record start to acquire the state for the existing
tasks, it might be defunct tasks simply aren't there anymore, in which
case there's nothing we can do.

But I haven't checked..

That said, yes it would be nice if we could cure this.
