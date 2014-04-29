Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaD2Vfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:35:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52726 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932130AbaD2Vfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:35:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: Change the calculation of next pstate
Date: Tue, 29 Apr 2014 23:52:19 +0200
Message-ID: <25001203.glgeYCc6ZZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535FD4A6.3050905@semaphore.gr>
References: <535D80C8.9090906@semaphore.gr> <CAKohpomhUk7RQ3YL3=wpVKSbK_oSkyYBRUZiqnHzWqrZ2DjRRA@mail.gmail.com> <535FD4A6.3050905@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 07:34:46 PM Stratos Karafotis wrote:
> On 29/04/2014 07:58 πμ, Viresh Kumar wrote:
> > Cc'd Dirk,
> > 
> > On 28 April 2014 03:42, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> >> Currently the driver calculates the next pstate proportional to
> >> core_busy factor and reverse proportional to current pstate.
> >>
> >> Change the above method and calculate the next pstate independently
> >> of current pstate.
> > 
> > We must mention why the change is required.
> > 
> 
> Hi Viresh,
> 
> Actually, I can't say that it's required. :)
> I just believe that calculation of next p-state should be independent
> from current one. In my opinion we can't scale the load across different
> p-states, because it's not always equivalent.
> 
> For example suppose a load of 100% because of a tight for loop in the
> current p-state. It will be also a 100% load in any other p-state.
> It will be wrong if we scale the load in the calculation formula
> according to the current p-state.
> 
> I included the test results in the change log to point out an improvement
> because of this patch.
> 
> I will enrich more the change log as you suggested.

Please do so.

Also, we need to take your patch to our power lab and see if we can reproduce
your results in other workloads.

And I'm waiting for the intel_pstate developer Dirk Brandewie to comment.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
