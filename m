Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3GAIGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:06:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3GAIGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:06:48 -0400
Date: Mon, 1 Jul 2013 10:06:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: sched: context tracking demolishes pipe-test
Message-ID: <20130701080638.GM6626@twins.programming.kicks-ass.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
 <20130630212940.GK6626@twins.programming.kicks-ass.net>
 <1372658875.7678.17.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372658875.7678.17.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:07:55AM +0200, Mike Galbraith wrote:
> On Sun, 2013-06-30 at 23:29 +0200, Peter Zijlstra wrote:
> 
> > Yeah, who'd have thought that putting stuff in the syscall path would've
> > made syscalls more expensive ;-)
> 
> (careful, you'll injure my innocence, Santa and the Tooth Fairy exist!)
> 
> > But yeah, that's a _lot_ more expensive.. I'd not be surprised if more
> > people would find that objectionable.
> 
> Distros may want some hot patching or _something_ before doing the usual
> new=turn-it-on thing.  Per trusty (spelled with 'c') old Q6600, the cost
> is pretty darn high.
> 
> -regress is my ~light regression testing config, carried forward from
> 3.6.32...master across all intervening trees.
> -regressx is plus CONFIG_RCU_USER_QS=y CONFIG_CONTEXT_TRACKING_FORCE=y
> -regressxx is plus full dynticks 
> 
> taskset -c 3 pipe-test 1
> 
> 2.6.32-regress    654.5 Khz            1.000
> 3.10.0-regress    652.1 Khz             .996     1.000
> 3.10.0-regressx   476.8 Khz             .728      .731
> 3.10.0-regressxx  275.6 Khz             .421      .422
> 
> tbench
> 
> 2.6.32-regress    327.502 MB/sec       1.000
> 3.10.0-regress    319.621 MB/sec        .975     1.000
> 3.10.0-regressx   292.894 MB/sec        .894      .916
> 3.10.0-regressxx  243.738 MB/sec        .744      .762
> 
> netperf TCP_RR
> 
> 2.6.32-regress   104041.84 Trans/sec   1.000
> 3.10.0-regress    94961.34 Trans/sec    .912     1.000
> 3.10.0-regressx   82383.33 Trans/sec    .791      .867
> 3.10.0-regressxx  61527.59 Trans/sec    .591      .647

So aside from the context tracking stuff, there's still a regression
we might want to look at. That's still a ~10% drop against 2.6.32 for
TCP_RR and few percents for tbench.
