Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaLBRrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:47:18 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:55768 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaLBRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:47:17 -0500
Message-ID: <1417542432.3924.39.camel@maggy.simpson.net>
Subject: Re: frequent lockups in 3.18rc4
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>,
        =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Dec 2014 10:47:12 -0700
In-Reply-To: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	 <20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org>
	 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
	 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	 <547bbe36.48548c0a.105c.779c@mx.google.com>
	 <20141201191431.GA17385@linux.vnet.ibm.com>
	 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	 <20141201230339.GA20487@ret.masoncoding.com>
	 <1417529606.3924.26.camel@maggy.simpson.net>
	 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 08:33 -0800, Linus Torvalds wrote:

> Looking again at that patch (the commit message still doesn't strike
> me as wonderfully explanatory :^) makes me worry, though.
> 
> Is that
> 
>         if (rq->skip_clock_update-- > 0)
>                 return;
> 
> really right? If skip_clock_update was zero (normal), it now gets set
> to -1, which has its own specific meaning (see "force clock update"
> comment in kernel/sched/rt.c). Is that intentional? That seems insane.

Yeah, it was intentional.  Least lines.

> Or should it be
> 
>         if (rq->skip_clock_update > 0) {
>                 rq->skip_clock_update = 0;
>                 return;
>         }
> 
> or what? Maybe there was a reason the patch never got applied even to -tip.

Peterz was looking at corner case proofing the thing.  Saving those
cycles has been entirely too annoying.

https://lkml.org/lkml/2014/4/8/295

	-Mike

