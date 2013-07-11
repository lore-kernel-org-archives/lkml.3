Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3GKW11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:27:27 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34347 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3GKW1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:27:25 -0400
Message-ID: <51DF307B.7060307@linux.vnet.ibm.com>
Date: Fri, 12 Jul 2013 03:53:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: viresh.kumar@linaro.org, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <6515593.XAmN11qlGF@vostro.rjw.lan>
In-Reply-To: <6515593.XAmN11qlGF@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-9574-0000-0000-000008AD76C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 04:03 AM, Rafael J. Wysocki wrote:
> On Friday, July 12, 2013 03:45:17 AM Srivatsa S. Bhat wrote:
>>
>> Hi,
> 
> Hi,
> 
>> Commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) caused
>> some subtle regressions in the cpufreq subsystem during suspend/resume.
>> This patchset is aimed at rectifying those problems, by fixing the regression
>> as well as achieving the original goal of that commit in a proper way.
>>
>> Patch 1 reverts the above commit, and is CC'ed to stable.
>>
>> Patches 2 - 5 reorganize the code and have no functional impact, and can go
>> in as general cleanups as well. This reorganization builds a base that the
>> rest of the patches will make use of.
>>
>> Patch 6 and 7 add a mechanism to perform light-weight init/tear-down of CPUs
>> in the cpufreq subsystem and finally patch 8 uses it to preserve sysfs files
>> across suspend/resume.
>>
>> All the patches apply on current mainline.
>>
>>
>> Robert, Durgadoss, it would be great if you could try it out and see if it works
>> well for your usecase. I tested it locally and cpufreq related files did retain
>> their permissions across suspend/resume. Let me know if it works fine in your
>> setup too.
>>
>> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
>> whether their systems work fine after:
>> a. applying only the first commit (this is what gets backported to stable)
>> b. applying all the commits
>>
>> (Note: I had to use Michael's fix[1] to avoid CPU hotplug deadlock while
>> testing this patchset. Though that patch also touches cpufreq subsystem, it
>> doesn't affect this patchset in any way and there is absolutely no dependency
>> between the two in terms of code. That fix just makes basic CPU hotplug work
>> without locking up on current mainline).
>>
>> [1]. https://lkml.org/lkml/2013/7/10/611
>>
>>
>> Thank you very much!
> 
> Thanks Srivatsa!
> 
> I'm going to take [1/8] for 3.11 and queue up the rest for 3.12 if people don't
> hate them.  This way we'll have some more testing coverage before they reach
> the mainline hopefully.
> 

Sounds great! Thanks a lot Rafael!
 
Regards,
Srivatsa S. Bhat

