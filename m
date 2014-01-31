Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaAaKZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:25:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42694 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:25:04 -0500
Date: Fri, 31 Jan 2014 11:24:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Len Brown <len.brown@intel.com>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, nicolas.pitre@linaro.org,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140131102455.GB8874@twins.programming.kicks-ass.net>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
 <20140130153150.GD5002@laptop.programming.kicks-ass.net>
 <52EA7D8A.6080604@linaro.org>
 <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org>
 <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
 <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EB6F65.8050008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:09:49PM +0530, Preeti U Murthy wrote:
> > Alternatively, can we enforce sanity on the cpuidle infrastructure to
> > make the index naturally ordered? If not, please explain why :-)
> 
> The commit id 71abbbf856a0e70 says that there are SOCs which could have
> their target_residency and exit_latency values change at runtime. This
> commit thus removed the ordering of the idle states according to their
> target_residency/exit_latency. Adding Len and Arjan to the CC.

OK that changelog pretty much destroys the ordered index. In which case
we need pretty accessors for useable numbers.

It would be good to reduce the number of cachelines those touch, but I'm
not at all familiar with the cpuidle state...
