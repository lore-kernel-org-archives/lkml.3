Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaAUMOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:14:32 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27757 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754476AbaAUMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:14:29 -0500
Date: Tue, 21 Jan 2014 12:14:29 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140121121429.GB19029@e103034-lin>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120163254.GA23051@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120163254.GA23051@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 20, 2014 at 04:32:54PM +0000, Pavel Machek wrote:
> On Tue 2014-01-07 16:19:47, Morten Rasmussen wrote:
> > Most modern systems use DVFS to save power by slowing down computation
> > throughput when less performance is necessary. The power/performance
> > relation is platform specific. Some platforms may have better energy
> > savings (energy per instruction) than others at low frequencies.
> > 
> > To have something to relate to, here is an anonymized example based on
> > a modern ARM platform:
> 
> And here is anonymized example I pulled out of my hat:
> 
> Ammount of anonymization       	 Usefulness of information      	 
> 0.0	   			 1.0
> 0.5				 0.05
> 1.0				 0.0
> 
> Come on, you can surely do better than "trust me, it is modern". Now
> we can't verify those numbers. And they don't make sense.
> 
> > Performance	Energy/instruction
> > 1.0		1.0
> > 1.3		1.6
> > 1.7		1.8
> > 2.0		1.9
> > 2.3		2.1
> > 2.7		2.4
> > 3.0		2.7
> > 
> > Performance is frequency (~instruction issue rate) and
> > energy/instruction is the energy cost of executing one (or a fixed
> > number of instructions) at that level of performance (frequency). For
> > this example, it costs 2.7x more energy per instruction to increase the
> > performance from 1.0 to 3.0 (3x). That is, the amount of work
> > (instructions) that can be done on one battery charge is reduced by 2.7x
> > (~63%) if you run as fast as possible (3.0) compared to running at
> > slowest frequency (1.0).
> 
> This very heavily depends on what you count to the total energy,
> right? And it is very hard to argue with you before you anonymized
> your numbers.

Just to clarify, the numbers above are cpu only as already stated in the
linux-pm thread referenced in the cover letter. We do of course need to
consider the total energy (cpu, gpu and memory at least) when verifying
whether any optimization does save energy or not.

As already discussed, battery power is suitable for this purpose on end
product form factor systems. However, for development hardware that
might be quite different (extra onboard devices and such).

> 
> Anyway, you assuming modern system, low frequency should be cca
> 0.5GHz, with high cca 1.5GHz. Do you claim that operation on 1.5GHz
> takes 9x the power of 0.5GHz operation?

On this particular platform, increasing the frequency by 3x increases
power by 8.1x.

> 
> Do you count DRAM to the power consumption?

As said above, the numbers are cpu only.

> 
> > To save energy, the higher frequencies should be avoided and only used
> > when the application performance requirements can not be satisfied
> > otherwise (e.g. spread tasks across more cpus if possible).
> 
> This is in very steep contrast with race-to-idle on the PCs.

I think Catalin already covered why race-to-idle isn't always the best
idea elsewhere in this thread. Basically, it is wasting a lot of energy
in use-cases like audio and video playback. I have provided descriptions
of these use-cases as part of this set of emails.

> 
> > When considering the total system power it may save energy in some
> > scenarios by running the cpu faster to allow other power hungry parts of
> > the system to be shut down faster. However, this is highly platform and
> > application dependent.
> 
> Aha. Devil is in the details. "I pulled random numbers out of the hat,
> and they are wrong, but they are wrong in platform specific way. And I
> anonymized them for you so that you can't verify them".
> 
> Can we talk specific machine, please? You are talking Android all the
> time, so pick one cellphone you care about, and provide real numbers...

As Catalin already said, there is a number of reason why we can't share
absolute numbers publicly. I think the numbers I posted give a pretty
good picture of the trade-offs involved in frequency scaling on a modern
ARM Soc. This posting was meant to a be a start of a discussion and I'm
hoping add more information (in anonymized form) in the future.

Morten
