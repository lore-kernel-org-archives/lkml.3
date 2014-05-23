Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaEWNTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:19:19 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:53024 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWNTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:19:16 -0400
Date: Fri, 23 May 2014 09:21:44 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH V3 1/8] cpufreq: cpufreq-cpu0: remove dependency on
 thermal
Message-ID: <20140523132144.GA3138@developer>
References: <cover.1400736536.git.viresh.kumar@linaro.org>
 <c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org>
 <20140522145209.GA5246@developer>
 <CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, May 23, 2014 at 10:03:27AM +0530, Viresh Kumar wrote:
> On 22 May 2014 20:22, Eduardo Valentin <edubezval@gmail.com> wrote:
> > However, on CPUs that needs thermal managment, it makes sense to have
> > such dependency, from functional perspective. Mainly because scaling
> > frequency and voltage up would be allowed only when thermal management
> > is enabled.
> 
> AFAIK, dependencies in KCONFIG are only for fixing compilation time issues.


Actually, they also impose module loading sequencing. 

> As some APIs wouldn't be available without enabling some config options..
> 
> If drivers fail at runtime because some API returned error, fix it for your
> platform instead and not bug KCONFIG for that.

Agreed, but I don't think this is the point of this thread, as you
already stated in your patch description.

> 
> Thought we might consider some runtime dependencies here as well. For
> example regulators. There probably are dummy routine available for cases
> where CONFIG_REGULATOR (or whatever) isn't enabled and driver would
> still compile, but it is guaranteed to fail as we don't continue when we get
> errors from regulator APIs..

I agree. We need to have runtime dependency, and that is the major
concern on my behalf. The problem of Kconfig dependency is that it
imposes sequencing only on module loading, not at boot sequencing.

Another way around is returning -EPROBE_DEFER when some API is not ready at device probing for instance.

> 
> Though I still feel that this driver should still support platforms without
> regulators (atleast in software, they might always have them on board :))..
> And so dependencies for regulators may also die out one day..
> 
> The dependencies here mean: "This driver would never ever work/compile
> if the dependencies aren't met.."
