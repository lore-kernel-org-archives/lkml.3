Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3KUO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:26:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49266 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752020Ab3KUO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:26:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Thu, 21 Nov 2013 15:39:18 +0100
Message-ID: <1830400.e7iQhdqTJH@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <528A1823.8080705@intel.com>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <CAKohpo=UjSqzE+Jg0s3taykHu4VinNUvLLhRm6pUXiyUc5F-3w@mail.gmail.com> <528A1823.8080705@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 18, 2013 09:37:39 PM Lan Tianyu wrote:
> On 11/18/2013 07:01 PM, Viresh Kumar wrote:
> > On 18 November 2013 16:27, Lan Tianyu <tianyu.lan@intel.com> wrote:
> >> How about introducing a resume/suspend callback pointer or list(if there
> >> are several places that need to deal with cpu resume/suspend) in the
> >> struct cpu and populate it in the cpufreq_add_dev()?
> >>
> >> The suspend/resume() of cpu_subsys needs to check the callback pointer
> >> and run it if available.
> >
> > That's almost a new infrastructure then and looks more hackish :)
> 
> The resume/suspend() must be stored in the struct driver->pm? :)
> 
> > Apart from that even cpufreq would be a bit hacky as we don't really need
> > per-cpu callbacks..
> >
> 
> This maybe depends on where we want the issue to be fixed, right?
> The cpufreq driver also can fix the issue if we run their cpu_driver 
> resume/suspend callback earlier.
> 
> Another point, I just see cpuidle_resume() and cpuidle_pause() are 
> called in the dpm_resume_noirq and dpm_suspend_noirq(). Not sure whether 
> this can be applied to cpufreq.

I don't see why not.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
