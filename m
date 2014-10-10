Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaJJJHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:07:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaJJJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:07:47 -0400
Date: Fri, 10 Oct 2014 11:07:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141010090743.GE10832@worktop.programming.kicks-ass.net>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
 <20140925172343.GX23693@e103034-lin>
 <20141002203428.GI2849@worktop.programming.kicks-ass.net>
 <CAKfTPtC0vNpg6vKoR_zUCF+ENOmRNDfZDAonSmL23ZYFA=AKNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtC0vNpg6vKoR_zUCF+ENOmRNDfZDAonSmL23ZYFA=AKNg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:38:40PM +0200, Vincent Guittot wrote:
> I have in mind some system where the max achievable freq of a core
> depends of how many cores are running simultaneously because of some
> HW constraint like max current. In this case, the CPU might not reach
> max frequency even with an always running task.
> Then, beside frequency scaling, their is the uarch invariance that is
> introduced by patch 4 that will generate similar behavior of the load.

This is a 'common' issue. x86 and powerpc also suffer this. It can be
the result of either thermal or power thresholds.


