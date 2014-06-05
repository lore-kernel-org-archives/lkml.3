Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaFEPDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:03:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61264 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaFEPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:03:18 -0400
Message-ID: <539086B3.2010804@gmail.com>
Date: Thu, 05 Jun 2014 08:03:15 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: dirk.brandewie@gmail.com, Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com> <20140604160230.GS29593@e103034-lin> <20140604172712.GJ13930@laptop.programming.kicks-ass.net> <2484761.vkWavnsDx3@vostro.rjw.lan> <20140605065205.GA3213@twins.programming.kicks-ass.net>
In-Reply-To: <20140605065205.GA3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 11:52 PM, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 11:56:55PM +0200, Rafael J. Wysocki wrote:
>> On Wednesday, June 04, 2014 07:27:12 PM Peter Zijlstra wrote:
>
>>> Well, we eventually want to go there I think. Although we still needed
>>> to come up with something for Intel, because I'm not at all sure how all
>>> that works.
>>
>> Do you mean power numbers or how P-states work on Intel in general?
>
> P-states, I'm still not at all sure how all that works on Intel and what
> we can sanely do with them.
>
> Supposedly Intel has a means of setting P-states (there's a driver after
> all), but then is completely free to totally ignore it and do something
> entirely different anyhow.

You can request a P state per core but the package does coordination at
a package level for the P state that will be used based on all requests.
This is due to the fact that most SKUs have a single VR and PLL. So
the highest P state wins.  When a core goes idle it loses it's vote
for the current package P state and that cores clock it turned off.

>
> And while APERF/MPERF allows observing what it did, its afaik, nigh on
> impossible to predict wtf its going to do, and therefore any such energy
> computation is going to be a PRNG at best.
>
> Now, given all that I'm not sure what we need that P-state driver for,
> so supposedly I'm missing something.

intel_pstate tries to keep the core P state as low as possible to satisfy
the given load, so when various cores go idle the package P state can be
as low as possible.  The big power win is a core going idle.

>
> Ideally Len (or someone equally in-the-know) would explain to me how
> exactly all that works and what we can rely upon. All I've gotten so far
> is, you can't rely on anything, and magik. Which is entirely useless.
>
The only thing you can rely on is that you will get "at least" the P state
requested in the presence of hardware coordination.
