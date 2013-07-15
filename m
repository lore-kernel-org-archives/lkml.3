Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3GOIr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:47:28 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49711 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3GOIr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:47:26 -0400
Message-ID: <51E3B645.8070705@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 14:13:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com,
        stern@rowland.harvard.edu, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51E3B262.6030005@intel.com>
In-Reply-To: <51E3B262.6030005@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071508-8878-0000-0000-000007F301D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:57 PM, Lan Tianyu wrote:
> On 2013年07月12日 06:15, Srivatsa S. Bhat wrote:
>>
>> Hi,
>>
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
> 
> Hi, I tested this patchset on my machine and the issue in bug 59781 has
> been resolved.
> 
> Tested-by: Tianyu Lan <tianyu.lan@intel.com>
> 

Awesome! Thanks a lot!

Regards,
Srivatsa S. Bhat

