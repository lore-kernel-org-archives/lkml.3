Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaHVCsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:48:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50262 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbaHVCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:48:15 -0400
Message-ID: <53F6AF66.10204@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 08:18:06 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Shilpasri G Bhat <shilpabhatppc@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] cpufreq: powernv: Register the driver with reboot notifier
References: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com> <53F57E51.4060200@gmail.com> <CAKohpon8ANWoy52B=_nSuNyHALrsQOLX4cA+690E=CifnVRFtg@mail.gmail.com>
In-Reply-To: <CAKohpon8ANWoy52B=_nSuNyHALrsQOLX4cA+690E=CifnVRFtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082202-6688-0000-0000-00000432FEAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 08/21/2014 11:56 AM, Viresh Kumar wrote:
> On 21 August 2014 10:36, Shilpasri G Bhat <shilpabhatppc@gmail.com> wrote:
>> The intention here is stop the cpufreq governor and then to set the cpus to
>> nominal frequency so as to ensure that the frequency won't be changed later.
>>
>> The .suspend callback of the driver is not called during reboot/kexec.
>> So we need an explicit reboot notifier to call cpufreq-suspend() to
>> suffice the requirement.
> 
> Hi Shilpa,
> 
> No, we can't allow any platform driver to misuse cpufreq_suspend().
> Platform drivers aren't *allowed* to call this routine.

At the moment this looks like the best way forward. We need to do this
cleanly by ensuring that we stop the governors and then call into the
driver to deal with the cpu frequency in its own way during reboot. The
best way to do this would be by calling this routine. Either this or
cpufreq_suspend() should be called in the reboot path generically. The
latter might not be an enticing option for other platforms.

Regards
Preeti U Murthy
> 
> Now the deal is how do we move to nominal frequency on reboot..
> @Rafael: Any suggestions? How do we ensure that governors
> are stopped on these notifiers, or if there is some other solution here?
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

