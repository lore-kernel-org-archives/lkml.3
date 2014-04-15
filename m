Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaDONZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:25:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDONZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:25:25 -0400
Date: Tue, 15 Apr 2014 15:25:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
Message-ID: <20140415132510.GO11182@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <22904760.5rGZuP5nsx@vostro.rjw.lan>
 <alpine.LFD.2.11.1404012141580.1571@knanqh.ubzr>
 <1930679.LtC4HPqI3x@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1930679.LtC4HPqI3x@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 01:43:00PM +0200, Rafael J. Wysocki wrote:
> > That's what this patch series is about.  The find_idlest_cpu code should 
> > look for the idle CPU with the shallowest idle state, or the one with 
> > the smallest load.  In this context "find_idlest_cpu" might become a 
> > misnomer.
> 
> Yes, clearly.  It should be called find_best_cpu or something like that.

Ha!, but for what purpose? We already have find_busiest_cpu() to find
the CPU to steal work from. The converse action, currently called
find_idlest_cpu() is finding the CPU where to put work.

'Best' is ambiguous in all regards, it doesn't convey the direction nor
the quality sorted on.

So while idlest might be somewhat of a misnomer, it at least conveys the
directional thing fairly well. Also we are still searching the least
busy, and preferable an idle, cpu. 'Idlest' being a superlative also
conveys the meaning of order.
