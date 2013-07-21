Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3GUKly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 06:41:54 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60825 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3GUKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 06:41:52 -0400
Message-ID: <51EBBA17.1070308@linux.vnet.ibm.com>
Date: Sun, 21 Jul 2013 16:08:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com,
        stern@rowland.harvard.edu, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51DF307B.7060307@linux.vnet.ibm.com> <51E56382.3020609@gmx.de> <2829832.mz5UcF7ZkY@vostro.rjw.lan> <51E6B7F7.6020901@gmx.de> <51E6BD0E.1020101@linux.vnet.ibm.com> <51EB9F3E.70608@linux.vnet.ibm.com> <51EBAC79.5090606@gmx.de>
In-Reply-To: <51EBAC79.5090606@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072110-3864-0000-0000-0000092E5D78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 03:10 PM, Toralf Förster wrote:
> On 07/21/2013 10:43 AM, Srivatsa S. Bhat wrote:
>> On 07/17/2013 09:19 PM, Srivatsa S. Bhat wrote:
>>> On 07/17/2013 08:57 PM, Toralf Förster wrote:
>>>> On 07/16/2013 11:32 PM, Rafael J. Wysocki wrote:
>>>>> On Tuesday, July 16, 2013 05:15:14 PM Toralf Förster wrote:
>> [...]
>>>>>> sry - here again with full quote of the email :
>>>>>>
>>>>>> I applied patch [1/8] on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup
>>>>>> cycles fine and crashed the system at the 3rd attempt / one times just at
>>>>>> the 4th (blinking power led, no sysrq, ...).
>>>>>>
>>>>>> Applying patch 1-8 on top of that tree differs in that way that it
>>>>>> crashes now the system even at the 1st attempt or at least at the 2nd
>>>>>>
>>>>>> My hardware is a ThinkPad T420 with latest BIOS and a 32 bit stable
>>>>>> Gentoo Linux - FWIW .config attached.
>>>>>
>>>>> I think you'll need the fixes first, basically [1/8] from this series and
>>>>> this: https://patchwork.kernel.org/patch/2827512/ .
>>>>>
>>>>> Please try to run with these two things applied only and see how that goes.
>>>>>
>>>>> Thanks,
>>>>> Rafael
>>>>>
>>>>>
>>>> That was it.
>>>>
>>>> Applying https://patchwork.kernel.org/patch/2827512/ and then patch
>>>> [1/8] on top of v3.11-rc1-8-g47188d3 works fine and solved the reported
>>>> issue.
>>>>
>>>> Furthermore applying patches 2-8 works too - suspend/wakeup works fine
>>>> and frequencies are scaled right after wakeup at the T420.
>>>>
>>>
>>> Phew! Finally :-)
>>>
>>> Thank you for all your testing efforts!
>>>
>>
>> Rafael, Viresh, any thoughts on picking up patches 2-8 from this series
>> for 3.12?
> 
> What's about the additional patch Rafael adviced me in this thread:
> https://patchwork.kernel.org/patch/2827512/
> ?
> 
> On my ThinkPad T420 I do have to apply this on top of 3.10.1 otherwise I
> do suffer from the hang during s2ram.
> 

Rafael already picked it up and in fact its now in the mainline kernel
as commit:

commit e8d05276f236ee6435e78411f62be9714e0b9377
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Tue Jul 16 22:46:48 2013 +0200

    cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression
    

Thanks for following up on that fix, Toralf!
Regards,
Srivatsa S. Bhat

