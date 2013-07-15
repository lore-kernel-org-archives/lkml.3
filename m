Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3GOGoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:44:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48020 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3GOGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:44:05 -0400
Message-ID: <51E39963.70605@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 12:10:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51E11C82.8000805@gmx.de> <51E15B11.4070907@gmx.de>
In-Reply-To: <51E15B11.4070907@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071506-5816-0000-0000-000008E85269
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 07:20 PM, Toralf Förster wrote:
> On 07/13/2013 11:23 AM, Toralf Förster wrote:
>> On 07/12/2013 12:15 AM, Srivatsa S. Bhat wrote:
>>> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
>>> whether their systems work fine after:
>>> a. applying only the first commit (this is what gets backported to stable)
>>
>> applied on top of straight 3.10 .0 : Breaks my system completely -
> 
> overlooked, that the 8 patches are 3.11/3.12 material - but nevertheless :
> 

Let me clarify where to apply these patches:

Assuming that you are using mainline (not -stable) for your testing, this is how
it goes:

For mainline v3.10 (final release, commit 8bb495e3f):

You need to apply 2 patches, in the order mentioned below:
   1. Commit f51e1eb63d (cpufreq: Fix cpufreq regression after suspend/resume)
   2. Patch 1/8 in this patchset. https://lkml.org/lkml/2013/7/11/661
      
Those 2 together, should be able to fix all the cpufreq regression you
originally saw with commit a66b2e (cpufreq: Preserve sysfs files across
suspend/resume).

------

Now, coming to current mainline, ie., 3.10+ (after 3.10, in-between the merge
window), you need to test two different things:

Scenario 1:
    Apply only patch 1/8 in this patchset. https://lkml.org/lkml/2013/7/11/661
    Check if cpufreq behaves fine after suspend/resume.

Scenario 2:
      Apply all the 8 patches in this patchset, and check if cpufreq still
      works fine after suspend/resume.


Important note: 
--------------

This patchset and any of the patches/commits I mentioned above *do* *not* try
to fix any core suspend/resume regression. They only try to fix the *cpufreq*
regression related to suspend/resume, which commit a66b2e (cpufreq: Preserve
sysfs files across suspend/resume) had caused.

In other words, if basic suspend/resume itself is not working even before you
apply any of the patches mentioned above, then something *else* is totally
broken, and we need to address that separately.


> Applied 1/8 on top of v3.10-9289-g9903883 brought same bad picture as
> described for 3.10.0
> 
> And applying patches 1-8 on top of that commit id just gives the same
> pciture - systems hangs during s2ram completly
> 

Please verify whether suspend/resume works fine before applying any of the
patches. That's an important baseline. This patchset tries to fix only the
cpufreq regression, and not all the suspend/resume related problems (which
might have creeped in during the merge window).

> 
>> trying s2ram just blanks the console, lets the power led blinking,
>> neither sys-rq nor anything else worked now, no output to console nor to
>> syslog
>>
>>> b. applying all the commits
>> patch 2#8 doesn't apply at 3.10.0 (neither after patch 1#8 nor directly)
> 
> I attached the .config I'm using for my tests
> (/me wonders if it is worth to notice, that it is a 32bit system booted
> from an external USB drive ?)
> 


Regards,
Srivatsa S. Bhat

