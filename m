Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaATSRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:17:24 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32499 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752004AbaATSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:17:21 -0500
Date: Mon, 20 Jan 2014 18:16:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120181647.GJ29971@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120175431.GB25439@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120175431.GB25439@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:54:32PM +0000, Pavel Machek wrote:
> On Mon 2014-01-20 17:10:29, Catalin Marinas wrote:
> > On Mon, Jan 20, 2014 at 04:49:26PM +0000, Pavel Machek wrote:
> > > > To save energy, the higher frequencies should be avoided and only used
> > > > when the application performance requirements can not be satisfied
> > > > otherwise (e.g. spread tasks across more cpus if possible).
> > > 
> > > I argue this is untrue for any task where user waits for its
> > > completion with screen on. (And that's quite important subset).
> > > 
> > > Lets take Nokia n900 as an example. 
> > > 
> > > (source http://wiki.maemo.org/N900_Hardware_Power_Consumption)
> > > 
> > > Sleeping CPU: 2mA
> > > Screen on: 230mA
> > > CPU loaded: 250mA
> > > 
> > > Now, lets believe your numbers and pretend system can operate at 33%
> > > of speed with 11% power consumption.
> > > 
> > > Lets take task that takes 10 seconds on max frequency:
> > > 
> > >       ~ 10s * 470mA     	     	    = 4700mAs
> > > 
> > > You suggest running at 33% speed, instead; that means 30 seconds on
> > > low requency.
> > > 
> > > CPU on low: 25mA (assumed).
> > > 
> > >      ~ 30s * 255mA			    = 7650mAs
> > > 
> > > Hmm. So race to idle is good thing on Intel machines, and it is good
> > > thing on ARM design I have access to.
> > 
> > Race to idle doesn't mean that the screen goes off as well. Let's say
> > the screen stays on for 1 min and the CPU needs to be running for 10s
> > over this minute, in the first case you have:
> 
> No, it does not. I just assumed user is continuing to use his
> machine. Obviously, waiting 60 seconds with screen on will make the
> difference look smaller. But your solution still means user has to
> wait longer _and_ you consume more battery doing so.
> 
> And this is for any task where user waits for result with screen
> on. Like rendering a webpage. Like opening settings screen. Like
> installing application.

Page rendering should make very little difference to power since the
reading (screen on) time is much larger than the rendering (CPU) time.
But what I'm pointing at for 10s/60s ratios are thing like games or
video playing where the CPU is running for 1/6 of the time and idle for
the other 5/6. We get better energy figures by changing the run time to
3/6 and idle at 3/6.

> There are not too many background tasks on a cellphone.

For sleep time, screen off etc. there are some background tasks but here
the run-time doesn't matter much, it's probably more expensive to take
CPUs out of deep sleep states. What we want to optimise here is which
CPU to wake (like a little vs big).

> But hey, maybe you are right and running at lowest possible frequency
> is right. Please provide concrete numbers like I did.

They've been anonymised (for many reasons) and you have the right not to
trust them. But do you really think we are making up the numbers? We
have a great interest in the Linux scheduler working efficiently on the
ARM platforms rather than optimising it for non-existent scenarios. If
at some point this argument becomes a blocking factor, I'm sure we can
share the real numbers with the relevant parties under an NDA.

-- 
Catalin
