Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3GUJkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 05:40:19 -0400
Received: from mout.gmx.net ([212.227.15.19]:65179 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3GUJkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 05:40:17 -0400
Message-ID: <51EBAC79.5090606@gmx.de>
Date: Sun, 21 Jul 2013 11:40:09 +0200
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
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <51DF307B.7060307@linux.vnet.ibm.com> <51E56382.3020609@gmx.de> <2829832.mz5UcF7ZkY@vostro.rjw.lan> <51E6B7F7.6020901@gmx.de> <51E6BD0E.1020101@linux.vnet.ibm.com> <51EB9F3E.70608@linux.vnet.ibm.com>
In-Reply-To: <51EB9F3E.70608@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:M5CUM2S72u3X5u4o7xu5PR8Pjv2IMgX6ypfGyRlTrhcgrNShlTF
 5ymyySlny7HKxq4aOB4E3XFGGIZ0xrt0A4ApYXxnBju5qVdz9A0Cso5fpychx5Npgt+lzb/
 QSv97D/hmZjyxAzarBsfLIKJkWoK1h8cdyJvkMMYVvpAQYvvAAJu11y/ETWrHUiRLgnrsMM
 UkFyZDhCl0S0uzzGX60hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 10:43 AM, Srivatsa S. Bhat wrote:
> On 07/17/2013 09:19 PM, Srivatsa S. Bhat wrote:
>> On 07/17/2013 08:57 PM, Toralf Förster wrote:
>>> On 07/16/2013 11:32 PM, Rafael J. Wysocki wrote:
>>>> On Tuesday, July 16, 2013 05:15:14 PM Toralf Förster wrote:
> [...]
>>>>> sry - here again with full quote of the email :
>>>>>
>>>>> I applied patch [1/8] on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup
>>>>> cycles fine and crashed the system at the 3rd attempt / one times just at
>>>>> the 4th (blinking power led, no sysrq, ...).
>>>>>
>>>>> Applying patch 1-8 on top of that tree differs in that way that it
>>>>> crashes now the system even at the 1st attempt or at least at the 2nd
>>>>>
>>>>> My hardware is a ThinkPad T420 with latest BIOS and a 32 bit stable
>>>>> Gentoo Linux - FWIW .config attached.
>>>>
>>>> I think you'll need the fixes first, basically [1/8] from this series and
>>>> this: https://patchwork.kernel.org/patch/2827512/ .
>>>>
>>>> Please try to run with these two things applied only and see how that goes.
>>>>
>>>> Thanks,
>>>> Rafael
>>>>
>>>>
>>> That was it.
>>>
>>> Applying https://patchwork.kernel.org/patch/2827512/ and then patch
>>> [1/8] on top of v3.11-rc1-8-g47188d3 works fine and solved the reported
>>> issue.
>>>
>>> Furthermore applying patches 2-8 works too - suspend/wakeup works fine
>>> and frequencies are scaled right after wakeup at the T420.
>>>
>>
>> Phew! Finally :-)
>>
>> Thank you for all your testing efforts!
>>
> 
> Rafael, Viresh, any thoughts on picking up patches 2-8 from this series
> for 3.12?

What's about the additional patch Rafael adviced me in this thread:
https://patchwork.kernel.org/patch/2827512/
?

On my ThinkPad T420 I do have to apply this on top of 3.10.1 otherwise I
do suffer from the hang during s2ram.

>>From the discussions on this thread so far, there are no pending issues:
> Toralf verified that these patches work fine on his system, as he mentioned
> above, and Tianyu Lan independently tested this patchset and found no
> issues with them. Also, Viresh analyzed the refcounting used in the patches
> and we came to the conclusion that there is no problem with them either.
> 
>  
> Regards,
> Srivatsa S. Bhat
> 
> 
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
