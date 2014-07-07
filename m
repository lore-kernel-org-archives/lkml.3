Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaGGOQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:16:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58679 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaGGOQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:16:33 -0400
Date: Mon, 7 Jul 2014 15:16:27 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140707141627.GB4485@e103687>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140703231950.GA4881@intel.com>
 <20140704110612.GA6120@e103034-lin>
 <20140706190523.GA12113@intel.com>
MIME-Version: 1.0
In-Reply-To: <20140706190523.GA12113@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Jul 2014 14:16:28.0242 (UTC) FILETIME=[0AF97320:01CF99EE]
X-MC-Unique: 114070715163103901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 08:05:23PM +0100, Yuyang Du wrote:
> Hi Morten,
> 
> Thanks, got it. Then another question,
> 
> On Fri, Jul 04, 2014 at 12:06:13PM +0100, Morten Rasmussen wrote:
> > The patch set essentially puts tasks where it is most energy-efficient
> > guided by the platform energy model. That should benefit any platform,
> > SMP and big.LITTLE. That is at least the goal.
> > 
> 
> I understand energy_diff_* functions are based on the energy model (though I
> have not dived into the detail of how you change load balancing based on
> energy_diff_*).
> 
> Speaking of the engergy model, I am not sure why elaborate "imprecise" energy
> numbers do a better job than only a general statement: higher freq, more cap,
> and more power.

The idea is that the energy model allows the scheduler to estimate the
energy efficiency of the cpus under any load scenario. That way, the
scheduler can estimate the energy implications of every choice it makes.
Whether it is cheaper (in terms of energy) to increase frequency on the
currently awake cpu instead of waking up more. Which cpu is the cheapest
to wake up if another one is needed. And so on.

> Even for big.LITTLE systems, big and little CPUs also follow that statement
> respectively. Then it is just a matter of where to place tasks between them.
> Under such, the energy model might be useful, but still probably cpu_power_orig
> (from Vincent) might be enough.

cpu_power doesn't tell you anything about energy-efficiency. There is no
link with frequency scaling. No representation of power domains. I don't
see how you can make energy aware decisions without having just a vague
idea about the impact of decisions. You need to consider energy
efficiency to get the most out of big.LITTLE. I believe the same is true
to some extend for SMP systems with aggressive cpu power management.

Could you elaborate on what you mean by 'a general statement'?

Thanks,
Morten

