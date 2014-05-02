Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaEBFld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:41:33 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63590 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBFlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:41:32 -0400
Message-ID: <1399009289.5233.39.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 07:41:29 +0200
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

BTW, we used to have avg_overlap and a sync less heuristic to improve
the accuracy of the sync wakeup hint, but I ripped it out because it was
dead wrong far too often.  You can try reviving it, but preemption among
other things break it.  You'll have better luck with a simple context
switch rate heuristic, but that's less than perfect too.

-Mike

