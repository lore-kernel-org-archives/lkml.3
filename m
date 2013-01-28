Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3A1L2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:28:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1L2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:28:21 -0500
Message-ID: <1359372481.5783.132.camel@marge.simpson.net>
Subject: Re: [patch] sched: minimalist select_idle_sibling() bouncing cow
 syndrome fix
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 28 Jan 2013 12:28:01 +0100
In-Reply-To: <20130128112145.GA23495@gmail.com>
References: <1359273021.5803.80.camel@marge.simpson.net>
	 <20130128105304.GC20263@gmail.com>
	 <1359371965.5783.127.camel@marge.simpson.net>
	 <20130128112145.GA23495@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:a/VPJl5lfNZarCmjzhgTO4PB+J1k9O6PZop42ogKjjm
 5mONry+7tag5GPC6PEbEHHUZRziDd2nf/qau1Ew1pnnCEBIGzt
 /5xRPRLABZ9f7dGRVb8ocg17c5vWcJ1bPLHgoDQVjmrJRJ/ER+
 lFMp1jnEfF42O4saKnENGFKiAChkrgHpdFaq1ZtqmGiWCnkWHw
 cfzn2iss5JPzDfEw2HWBQquWnNyZd1EXkjdZ7GbkEqnc43Vo9W
 4cNTbKJur8GcuRPKGe2Cu0bTwZ59Gfs4Tp/Tdzex3CrvgJgt4I
 RsmTH/cvcOhjoklGEBjs92H4mLLI7jGIVY8ettbc8Nhw0VdNow
 Mg/UG2gKZIZsZMO1BJ1vHf4skMgBcKIpE6yKgttGyCW6cbmC0E
 X/W0PbCouMvrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 12:21 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <bitbucket@online.de> wrote:
> 
> > On Mon, 2013-01-28 at 11:53 +0100, Ingo Molnar wrote: 
> > > * Mike Galbraith <bitbucket@online.de> wrote:
> > > 
> > > > If the previous CPU is cache affine and idle, select it.
> > > 
> > > No objections in principle - but would be nice to have a 
> > > changelog with numbers, % of improvement included and so?
> > 
> > Well, that like was my changelog, guess it needs improvement.
> > 
> > Take 2.
> > 
> > sched: minimalist select_idle_sibling() bouncing cow syndrome fix
> > 
> > If the previous CPU is cache affine and idle, select it.
> > 
> > The current implementation simply traverses the sd_llc domain,
> > taking the first idle CPU encountered, which walks buddy pairs
> > hand in hand over the package, inflicting excruciating pain.
> > 
> > 1 tbench pair (worst case) in a 10 core + SMT package:
> > 
> > pre   15.22 MB/sec 1 procs
> > post 252.01 MB/sec 1 procs
> 
> Drool ... :-)

Yeah, it really is _that_ fugly as is.

> What would be a 'contrarian' test - i.e. a test where this could 
> hurt most?

There is none.  It cuts off no preemption escape routes for pgbench,
still has both good and evil faces for all to see, and some to turn to
stone ;-)  It only does one thing, don't do the unspeakable.

-Mike

