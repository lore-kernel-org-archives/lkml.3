Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab3KRNi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:38:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:47926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3KRNiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:38:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,723,1378882800"; 
   d="scan'208";a="429592565"
Message-ID: <528A1823.8080705@intel.com>
Date: Mon, 18 Nov 2013 21:37:39 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <5974906.WAPp3f3eVY@vostro.rjw.lan> <CAKohpo=PoAaYgLNEVkkTC6tzAH=5hKw4VWTsrjt2jQnr7+6Q_w@mail.gmail.com> <5229929.5JRiWnF6CT@vostro.rjw.lan> <5289A80B.7080808@linaro.org> <5289F29B.8050806@intel.com> <CAKohpo=UjSqzE+Jg0s3taykHu4VinNUvLLhRm6pUXiyUc5F-3w@mail.gmail.com>
In-Reply-To: <CAKohpo=UjSqzE+Jg0s3taykHu4VinNUvLLhRm6pUXiyUc5F-3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 07:01 PM, Viresh Kumar wrote:
> On 18 November 2013 16:27, Lan Tianyu <tianyu.lan@intel.com> wrote:
>> How about introducing a resume/suspend callback pointer or list(if there
>> are several places that need to deal with cpu resume/suspend) in the
>> struct cpu and populate it in the cpufreq_add_dev()?
>>
>> The suspend/resume() of cpu_subsys needs to check the callback pointer
>> and run it if available.
>
> That's almost a new infrastructure then and looks more hackish :)

The resume/suspend() must be stored in the struct driver->pm? :)

> Apart from that even cpufreq would be a bit hacky as we don't really need
> per-cpu callbacks..
>

This maybe depends on where we want the issue to be fixed, right?
The cpufreq driver also can fix the issue if we run their cpu_driver 
resume/suspend callback earlier.

Another point, I just see cpuidle_resume() and cpuidle_pause() are 
called in the dpm_resume_noirq and dpm_suspend_noirq(). Not sure whether 
this can be applied to cpufreq.

-- 
Best Regards
Tianyu Lan
