Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaGHJ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:28:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57222 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaGHJ2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:28:12 -0400
Date: Tue, 8 Jul 2014 10:28:07 +0100
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
Message-ID: <20140708092807.GC4485@e103687>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140703231950.GA4881@intel.com>
 <20140704110612.GA6120@e103034-lin>
 <20140706190523.GA12113@intel.com>
 <20140707141627.GB4485@e103687>
 <20140708002343.GC25653@intel.com>
MIME-Version: 1.0
In-Reply-To: <20140708002343.GC25653@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Jul 2014 09:28:08.0391 (UTC) FILETIME=[EDDF6D70:01CF9A8E]
X-MC-Unique: 114070810281006601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:23:43AM +0100, Yuyang Du wrote:
> Hi Morten,
> 
> On Mon, Jul 07, 2014 at 03:16:27PM +0100, Morten Rasmussen wrote:
> 
> > Could you elaborate on what you mean by 'a general statement'?
> 
> The general statement is: higher freq, more cap, and more power. More specific
> numbers are not needed, as they are just instances of this general statement.

I think I understand now. While that statement might be true for SMP
systems, it doesn't tell you the cost of chosing a higher frequency. If
you are optimizing for energy, you really care about energy per work (~
energy/instruction). The additional cost of going to a higher capacity
state very platform dependent. At least on typical modern ARM platforms,
the highest states are significantly more expensive to use, so you don't
want to use them unless you really have to.

If we don't have any energy cost information, we can't make an informed
decision whether it worth running faster (race-to-idle or consolidating
tasks on fewer cpus) or using more cpus (if that is possible).
 
> > cpu_power doesn't tell you anything about energy-efficiency. There is no
> > link with frequency scaling.
> 
> In general, more cpu_power, more freq, less energy-efficiency, as you said sometime ago.

Not in general :) For big.LITTLE it may be more energy efficient to run
a little cpu at a high frequency instead of using a big cpu at a low
frequency. For multi-cluster/package SMP it is not straight forward
either as it is more expensive to run the first cpu in a large power
domain than the additional cpus.

> 
> > No representation of power domains.
> 
> Represented by CPU topology?

Not really. The sched_domain hierarchy represents the cache hierarhcy
(and nodes for NUMA), but you don't necessarily have a power domains at
the same levels. But yes, the sched_domain hierarchy can be used for
this purpose as well if we attach the necessary power domain information
to it. That is basically what we do in this patch set.

Morten

