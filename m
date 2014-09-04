Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaIDGJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:09:03 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45486 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaIDGJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <19131121.D211TBerqb@vostro.rjw.lan>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
	<CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com>
	<53296AD0.5090908@linux.vnet.ibm.com>
	<19131121.D211TBerqb@vostro.rjw.lan>
Date: Thu, 4 Sep 2014 11:38:59 +0530
Message-ID: <CAKohpom0+bbyffZML2tJjXQDc+2q4PM8sVkL5pDA5WX=rmvtKA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 19:49, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

> That said, for the intel_pstate case ->stop() as proposed by Dirk is demonstrably
> sufficient and there are no other ->setpolicy drivers in sight wanting or needing
> anything else.
>
> So to me, (1) the new ->stop() should *only* be called for ->setpolicy drivers,
> because the purpose of it should be to "allow ->setpolicy drivers to do what the
> GOV_STOP will do for regular drivers" as you put it above, and (2) some code in
> the original intel_pstate's ->exit() may/should stay in there (instead of being
> moved to the new ->stop()), which is the only possibly remaining issue here.
>
> The whole discussion about possibly re-using ->stop() for ->target drivers goes
> in a totally wrong direction, because *if* ->target drivers need a new callback
> to be executed around where ->stop() is called for ->setpolicy drivers, *then*
> that has to be a *different* callback.
>
> And by the way, ->get() in fact has a different meaning for ->setpolicy drivers,
> so it would be good to consider logical separation of ->setpolicy and ->target
> drivers so that each kind has its own separate set of callbacks with no overlaps.
> That would make it easier to avoid breakage resulting from changes made with
> ->setpolicy drivers that also affect ->target drivers in unpredictable ways and
> the other way around.

Okay, I have picked up a very old thread but it looks more sensible to start
replying here..

Preeti (Cc'd) wants to do something similar, i.e. reduce freq of a
core before it
goes down. And the driver is probably: drivers/cpufreq/powernv-cpufreq.c, which
is ->target() type.

Now should we reuse the same callback ->stop_cpu() or implement a new one?
I don't know if adding a new callback would be a good idea here..

--
viresh
