Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaFGCeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:34:03 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34893 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaFGCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:34:01 -0400
Date: Fri, 6 Jun 2014 22:33:58 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Yuyang Du <yuyang.du@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
In-Reply-To: <20140606122740.GA9318@gmail.com>
Message-ID: <alpine.LFD.2.11.1406062224090.25775@knanqh.ubzr>
References: <20140604160230.GS29593@e103034-lin> <20140604172712.GJ13930@laptop.programming.kicks-ass.net> <2484761.vkWavnsDx3@vostro.rjw.lan> <20140605065205.GA3213@twins.programming.kicks-ass.net> <539086B3.2010804@gmail.com> <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net> <20140606003520.GB22261@intel.com> <20140606105036.GQ3213@twins.programming.kicks-ass.net> <20140606121305.GA8571@gmail.com> <20140606122740.GA9318@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Ingo Molnar wrote:

> In any case, even with turbo frequencies, switching power use is 
> probably an order of magnitude higher than leakage current power use, 
> on any marketable chip, so we should concentrate on being able to 
> cover this first order effect (P/work ~ V^2), before considering any 
> second order effects (leakage current).

Just so that people are aware... We'll have to introduce thermal 
constraint management into the scheduler mix as well at some point.  
Right now what we have is an ad hoc subsystem that simply monitors 
temperature and apply crude cooling strategies when some thresholds are 
met. But a better strategy would imply thermal "provisioning".


Nicolas
