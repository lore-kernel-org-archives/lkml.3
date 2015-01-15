Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbbAOMX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:23:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38226 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbAOMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:23:26 -0500
Date: Thu, 15 Jan 2015 13:23:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Juri Lelli <juri.lelli@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
Message-ID: <20150115122323.GU23965@worktop.programming.kicks-ass.net>
References: <2629881420411885@web9m.yandex.ru>
 <54AAABFB.3060109@unitn.it>
 <1420499241.3361.14.camel@yandex.ru>
 <20150107080155.1d42d123@luca-1225C>
 <1420633741.12772.10.camel@yandex.ru>
 <54B4D2DF.9010308@arm.com>
 <4500351421141200@web2m.yandex.ru>
 <20150113140436.GI25256@twins.programming.kicks-ass.net>
 <4632021421239387@web25g.yandex.ru>
 <54B7A33F.20904@unitn.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7A33F.20904@unitn.it>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 12:23:43PM +0100, Luca Abeni wrote:
> There are some parts of the patch that I do not understand (for example:
> if I understand well, if the task is not throttled you set dl_new to 1...
> And if it is throttled you change its current runtime and scheduling deadline...
> Why?)
> Anyway, I tested the patch and I confirm that it fixes the hang I originally
> reported.

I'll go look at the patch in a wee bit. But Juri, Luca, could you
describe the correct behaviour?

>From what I understand we should either modify the tasks run/sleep stats
when we change its parameters or we should schedule a delayed release of
the bandwidth delta (when it reaches its 0-lag point, if thats in the
future).

Doing neither will allow one to game the reservation system afaict.
