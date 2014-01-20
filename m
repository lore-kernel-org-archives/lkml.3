Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaATQta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:49:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57574 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaATQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:49:28 -0500
Date: Mon, 20 Jan 2014 17:49:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@kernel.org, rjw@rjwysocki.net,
        markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120164926.GB23051@amd.pavel.ucw.cz>
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

Hi!

> To save energy, the higher frequencies should be avoided and only used
> when the application performance requirements can not be satisfied
> otherwise (e.g. spread tasks across more cpus if possible).

I argue this is untrue for any task where user waits for its
completion with screen on. (And that's quite important subset).

Lets take Nokia n900 as an example. 

(source http://wiki.maemo.org/N900_Hardware_Power_Consumption)

Sleeping CPU: 2mA
Screen on: 230mA
CPU loaded: 250mA

Now, lets believe your numbers and pretend system can operate at 33%
of speed with 11% power consumption.

Lets take task that takes 10 seconds on max frequency:

      ~ 10s * 470mA     	     	    = 4700mAs

You suggest running at 33% speed, instead; that means 30 seconds on
low requency.

CPU on low: 25mA (assumed).

     ~ 30s * 255mA			    = 7650mAs

Hmm. So race to idle is good thing on Intel machines, and it is good
thing on ARM design I have access to.

And you even acknowledge it here, right:

> When considering the total system power it may save energy in some
> scenarios by running the cpu faster to allow other power hungry parts of
> the system to be shut down faster. However, this is highly platform and
> application dependent.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
