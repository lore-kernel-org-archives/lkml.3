Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3GAGIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:08:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3GAGH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:07:59 -0400
Message-ID: <1372658875.7678.17.camel@marge.simpson.net>
Subject: Re: sched: context tracking demolishes pipe-test
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 01 Jul 2013 08:07:55 +0200
In-Reply-To: <20130630212940.GK6626@twins.programming.kicks-ass.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
	 <20130630212940.GK6626@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:TCK99t9c1bnuNYn/bFScxTF0TJWF5bP05eTMcluD/Uc
 M1qahSnkVboeeA5OaB9Ex5FlCJcMuZGj811L4xntTZyUs7EZuz
 o+qpPB40a5ZQstKWDklfMIKpLJklaaxfkP7DgHgynvh13dnvXG
 DuWy9ealDRd4PxFVbN5WsJxZg9KhzT0S6oYDM5SgLbxNJC/1yT
 1TzVqeRtWzKzewZlwxCShqWD94glicdXMVJkXpPC6QfMO9w9+K
 MJkpBeTART+IUgf6Q4xnuwkhu3/JEyGj75FDAhSZIimso2WK80
 YgE7zEcn2zDZR3WYRO9r6d9m4RZz1pSYlbrkVwHwUr4Riykt0a
 HYjxuJ5TnRnU4FNk37M3J0PwqgFkNe7iSY8sFAFH5EBemmBq9W
 mOgfulY7yqNWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-30 at 23:29 +0200, Peter Zijlstra wrote:

> Yeah, who'd have thought that putting stuff in the syscall path would've
> made syscalls more expensive ;-)

(careful, you'll injure my innocence, Santa and the Tooth Fairy exist!)

> But yeah, that's a _lot_ more expensive.. I'd not be surprised if more
> people would find that objectionable.

Distros may want some hot patching or _something_ before doing the usual
new=turn-it-on thing.  Per trusty (spelled with 'c') old Q6600, the cost
is pretty darn high.

-regress is my ~light regression testing config, carried forward from
3.6.32...master across all intervening trees.
-regressx is plus CONFIG_RCU_USER_QS=y CONFIG_CONTEXT_TRACKING_FORCE=y
-regressxx is plus full dynticks 

taskset -c 3 pipe-test 1

2.6.32-regress    654.5 Khz            1.000
3.10.0-regress    652.1 Khz             .996     1.000
3.10.0-regressx   476.8 Khz             .728      .731
3.10.0-regressxx  275.6 Khz             .421      .422

tbench

2.6.32-regress    327.502 MB/sec       1.000
3.10.0-regress    319.621 MB/sec        .975     1.000
3.10.0-regressx   292.894 MB/sec        .894      .916
3.10.0-regressxx  243.738 MB/sec        .744      .762

netperf TCP_RR

2.6.32-regress   104041.84 Trans/sec   1.000
3.10.0-regress    94961.34 Trans/sec    .912     1.000
3.10.0-regressx   82383.33 Trans/sec    .791      .867
3.10.0-regressxx  61527.59 Trans/sec    .591      .647

