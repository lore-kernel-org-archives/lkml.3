Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3GPPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:15:47 -0400
Received: from mout.gmx.net ([212.227.17.22]:52592 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab3GPPPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:15:43 -0400
Message-ID: <51E56382.3020609@gmx.de>
Date: Tue, 16 Jul 2013 17:15:14 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com,
        stern@rowland.harvard.edu, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <6515593.XAmN11qlGF@vostro.rjw.lan> <51DF307B.7060307@linux.vnet.ibm.com>
In-Reply-To: <51DF307B.7060307@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Qspl41qUiN6PqUlVa1xwsFByQ/0j4iYwI94OT6JT8+hTzAj9vVa
 h4pfMgbzViFeXk4JEhcKq57EHhJDU8OEnL3ALCNGnsC/Ze87uQySw+EkS+zjXrn16dvNMZx
 dhY6eMn7I7K2a0Fsq5h3xOxzIqeEggunEU5FQofVXoLMqaHLyi3ev4bkkk4qO1EimOraKiW
 mFH8blf89YsK8OVzfG58A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:23 AM, Srivatsa S. Bhat wrote:
> On 07/12/2013 04:03 AM, Rafael J. Wysocki wrote:
>> On Friday, July 12, 2013 03:45:17 AM Srivatsa S. Bhat wrote:
>>>
>>> Hi,
>>
>> Hi,
>>
>>> Commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) caused
>>> some subtle regressions in the cpufreq subsystem during suspend/resume.
>>> This patchset is aimed at rectifying those problems, by fixing the regression
>>> as well as achieving the original goal of that commit in a proper way.
>>>
>>> Patch 1 reverts the above commit, and is CC'ed to stable.
>>>
>>> Patches 2 - 5 reorganize the code and have no functional impact, and can go
>>> in as general cleanups as well. This reorganization builds a base that the
>>> rest of the patches will make use of.
>>>
>>> Patch 6 and 7 add a mechanism to perform light-weight init/tear-down of CPUs
>>> in the cpufreq subsystem and finally patch 8 uses it to preserve sysfs files
>>> across suspend/resume.
>>>
>>> All the patches apply on current mainline.
>>>
>>>
>>> Robert, Durgadoss, it would be great if you could try it out and see if it works
>>> well for your usecase. I tested it locally and cpufreq related files did retain
>>> their permissions across suspend/resume. Let me know if it works fine in your
>>> setup too.
>>>
>>> And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
>>> whether their systems work fine after:
>>> a. applying only the first commit (this is what gets backported to stable)
>>> b. applying all the commits
>>>
>>> (Note: I had to use Michael's fix[1] to avoid CPU hotplug deadlock while
>>> testing this patchset. Though that patch also touches cpufreq subsystem, it
>>> doesn't affect this patchset in any way and there is absolutely no dependency
>>> between the two in terms of code. That fix just makes basic CPU hotplug work
>>> without locking up on current mainline).
>>>
>>> [1]. https://lkml.org/lkml/2013/7/10/611
>>>
>>>
>>> Thank you very much!
>>
>> Thanks Srivatsa!
>>
>> I'm going to take [1/8] for 3.11 and queue up the rest for 3.12 if people don't
>> hate them.  This way we'll have some more testing coverage before they reach
>> the mainline hopefully.
>>

On 07/16/2013 01:25 AM, Rafael J. Wysocki wrote:> On Monday, July 15, 2013 07:38:02 PM Toralf Förster wrote:
> Sorry, I have no idea what 1#8 means.

sry - here again with full quote of the email :

I applied patch [1/8] on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup
cycles fine and crashed the system at the 3rd attempt / one times just at
the 4th (blinking power led, no sysrq, ...).

Applying patch 1-8 on top of that tree differs in that way that it
crashes now the system even at the 1st attempt or at least at the 2nd

My hardware is a ThinkPad T420 with latest BIOS and a 32 bit stable
Gentoo Linux - FWIW .config attached.

> 
> Sounds great! Thanks a lot Rafael!
>  
> Regards,
> Srivatsa S. Bhat
> 
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
