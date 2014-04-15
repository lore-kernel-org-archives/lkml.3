Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaDONR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:17:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54906 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaDONRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:17:55 -0400
Date: Tue, 15 Apr 2014 15:17:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
Message-ID: <20140415131745.GN11182@twins.programming.kicks-ass.net>
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
> > We need to ensure the cpuidle data structure is not going away (e.g. 
> > cpuidle driver module removal) while another CPU looks at it though.  
> > The timing would have to be awfully weird for this to happen but still.
> 
> Well, I'm not sure if that is a real concern.  Only a couple of drivers try
> to implement module unloading and I guess this isn't tested too much, so
> perhaps we should just make it impossible to unload a cpuidle driver?

The 'easy' solution is to mandate the use of rcu_read_lock() around the
dereference and make all cpuidle drivers put an rcu_barrier() in their
module unload path.
