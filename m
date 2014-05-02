Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaEBF7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:59:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43882 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBF7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:59:00 -0400
Message-ID: <1399010337.5233.50.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 07:58:57 +0200
In-Reply-To: <1399008721.5233.35.camel@marge.simpson.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399008721.5233.35.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 07:32 +0200, Mike Galbraith wrote: 
> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote: 
> > Currently sync wakeups from the wake_affine code cannot work as
> > designed, because the task doing the sync wakeup from the target
> > cpu will block its wakee from selecting that cpu.
> > 
> > This is despite the fact that whether or not the wakeup is sync
> > determines whether or not we want to do an affine wakeup...
> 
> If the sync hint really did mean we ARE going to schedule RSN, waking
> local would be a good thing.  It is all too often a big fat lie.

One example of that is say pgbench.  The mother of all work (server
thread) for that load wakes with sync hint.  Let the server wake the
first of a small herd CPU affine, and that first wakee then preempt the
server (mother of all work) that drives the entire load.

Byebye throughput.

When there's only one wakee, and there's really not enough overlap to at
least break even, waking CPU affine is a great idea.  Even when your
wakees only run for a short time, if you wake/get_preempted repeat, the
load will serialize.

-Mike

