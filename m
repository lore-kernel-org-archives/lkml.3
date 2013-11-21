Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3KUQRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:17:24 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39743 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3KUQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:17:21 -0500
MIME-Version: 1.0
In-Reply-To: <1531674.UoqyyWSbOg@vostro.rjw.lan>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<5289A80B.7080808@linaro.org>
	<CAKohpon5L21yXg=GAuSLSgkr_66iRSn_uUWKZ1FhwD3zuQNb_A@mail.gmail.com>
	<1531674.UoqyyWSbOg@vostro.rjw.lan>
Date: Thu, 21 Nov 2013 21:47:20 +0530
Message-ID: <CAKohpo=e+0cpq5XfWpM6Jm0VrnzzAu-xybpucEG6sRL0ydBmLQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2013 20:08, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, November 20, 2013 11:04:28 AM Viresh Kumar wrote:
>> On 18 November 2013 11:09, viresh kumar <viresh.kumar@linaro.org> wrote:

>> > Because in our usecase, we just want to know when suspend has started or
>> > resume has finished. And so we really don't need a per cpu callback.
>
> But it won't hurt I suppose?

Hmm.. getting a single call to cpufreq core would be faster for sure. Otherwise
we need to mark all the calls leaving the first one as no-ops..

> That actually isn't correct.  On systems with ACPI the processor driver binds to
> those devices.  So the processor driver could use PM callbacks on those systems
> in principle.

> Introduce proper drivers for processors?  All of the cpuidle and cpufreq stuff
> currently works by using its own homegrown device registration methods etc, but
> surely that doesn't have to be the case?

Hmm.. So you are asking for a new cpu-driver which can be used by cpufreq and
cpuidle to get callback? If yes, where such driver will exist? And will the ACPI
processor-drivers exist parallely? Or something else?

>> > And I really feel even if we would be able to use cpu callbacks for
>> > suspend/resume, that would be a real *Hack*, because our framework doesn't want
>> > to get a callback for each of its devices (i.e. cpu) but a single callback at
>> > certain instances..
>
> Oh really?  So CPUs are not individual devices any more or what?

I am not calling cpu callbacks as hack but using them for cpufreq looked like
one to me.

Replying here to the other mail as well:

On 21 November 2013 20:09, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, November 18, 2013 09:37:39 PM Lan Tianyu wrote:
>> Another point, I just see cpuidle_resume() and cpuidle_pause() are
>> called in the dpm_resume_noirq and dpm_suspend_noirq(). Not sure whether
>> this can be applied to cpufreq.
>
> I don't see why not.

Interesting. So you would be happy if I add such calls after freezing userspace
and before restoring it back for cpufreq?
