Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaATQc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:32:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54631 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaATQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:32:56 -0500
Date: Mon, 20 Jan 2014 17:32:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@kernel.org, rjw@rjwysocki.net,
        markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120163254.GA23051@amd.pavel.ucw.cz>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-07 16:19:47, Morten Rasmussen wrote:
> Most modern systems use DVFS to save power by slowing down computation
> throughput when less performance is necessary. The power/performance
> relation is platform specific. Some platforms may have better energy
> savings (energy per instruction) than others at low frequencies.
> 
> To have something to relate to, here is an anonymized example based on
> a modern ARM platform:

And here is anonymized example I pulled out of my hat:

Ammount of anonymization       	 Usefulness of information      	 
0.0	   			 1.0
0.5				 0.05
1.0				 0.0

Come on, you can surely do better than "trust me, it is modern". Now
we can't verify those numbers. And they don't make sense.

> Performance	Energy/instruction
> 1.0		1.0
> 1.3		1.6
> 1.7		1.8
> 2.0		1.9
> 2.3		2.1
> 2.7		2.4
> 3.0		2.7
> 
> Performance is frequency (~instruction issue rate) and
> energy/instruction is the energy cost of executing one (or a fixed
> number of instructions) at that level of performance (frequency). For
> this example, it costs 2.7x more energy per instruction to increase the
> performance from 1.0 to 3.0 (3x). That is, the amount of work
> (instructions) that can be done on one battery charge is reduced by 2.7x
> (~63%) if you run as fast as possible (3.0) compared to running at
> slowest frequency (1.0).

This very heavily depends on what you count to the total energy,
right? And it is very hard to argue with you before you anonymized
your numbers.

Anyway, you assuming modern system, low frequency should be cca
0.5GHz, with high cca 1.5GHz. Do you claim that operation on 1.5GHz
takes 9x the power of 0.5GHz operation?

Do you count DRAM to the power consumption?

> To save energy, the higher frequencies should be avoided and only used
> when the application performance requirements can not be satisfied
> otherwise (e.g. spread tasks across more cpus if possible).

This is in very steep contrast with race-to-idle on the PCs.

> When considering the total system power it may save energy in some
> scenarios by running the cpu faster to allow other power hungry parts of
> the system to be shut down faster. However, this is highly platform and
> application dependent.

Aha. Devil is in the details. "I pulled random numbers out of the hat,
and they are wrong, but they are wrong in platform specific way. And I
anonymized them for you so that you can't verify them".

Can we talk specific machine, please? You are talking Android all the
time, so pick one cellphone you care about, and provide real numbers...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
