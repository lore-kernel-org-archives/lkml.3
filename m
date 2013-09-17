Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3IQScY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:32:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63972 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752689Ab3IQScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:32:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
Date: Tue, 17 Sep 2013 20:43:30 +0200
Message-ID: <4586351.EPC2yFj4Nj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=_bhaws44_XEf=DEjbVtiRfYHeMm-cK=bHo1Sed14kAg@mail.gmail.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org> <52387343.7040007@wwwdotorg.org> <CAKohpo=_bhaws44_XEf=DEjbVtiRfYHeMm-cK=bHo1Sed14kAg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 17, 2013 09:48:08 PM Viresh Kumar wrote:
> On 17 September 2013 20:50, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 09/11/2013 11:25 PM, Viresh Kumar wrote:
> >> This broke after a recent change "cedb70a cpufreq: Split __cpufreq_remove_dev()
> >> into two parts" from Srivatsa..
> >>
> >> Consider a scenario where we have two CPUs in a policy (0 & 1) and we are
> >> removing cpu 1. On the call to __cpufreq_remove_dev_prepare() we have cleared 1
> >> from policy->cpus and now on a call to __cpufreq_remove_dev_finish() we read
> >> cpumask_weight of policy->cpus, which will come as 1 and this code will behave
> >> as if we are removing the last cpu from policy :)
> >>
> >> Fix it by clearing cpu mask in __cpufreq_remove_dev_finish() instead of
> >> __cpufreq_remove_dev_prepare().
> >
> > I see this patch isn't in linux-next yet, nor did it make 3.12-rc1. I
> > assume it'll make 3.12-rc2? It solves various CPU hotplug and
> > suspend/resume issues for me.
> 
> Yes, I have asked Rafael to get this in for rc2 and few others too..
> Waiting for his reply though..

Care to remind me what the other patches were?

Rafael

