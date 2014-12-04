Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaLDLfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:35:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42048 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaLDLfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:35:30 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-7a-548046ff8714
Message-id: <548046F8.5020001@samsung.com>
Date: Thu, 04 Dec 2014 14:35:20 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, aquini@redhat.com,
        Joe Perches <joe@perches.com>, manfred@colorfullife.com,
        avagin@openvz.org, LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero'
 variable
References: <547F0486.7020400@samsung.com>
 <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
 <20141203152524.4e2916fdbec5ebb16f1fe4d3@linux-foundation.org>
 <20141203161917.33350777442ce949fb8e98f4@linux-foundation.org>
In-reply-to: <20141203161917.33350777442ce949fb8e98f4@linux-foundation.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Vd3/bg0hBh9+a1jMWb+GzaJn904m
	ixkPf7FYrFh6jcXi+cOH7BYTHraxW8y+/xgo9uw+k8X2Z2+ZLG4+n8NisbLzAatF/+Pv7BaX
	d81hs9h3fwqrxYe1p1gsTvStZbJoW7KRyUHQ48XCLcweE5/OZPV4uX0Dm8fOWXfZPRZsKvXY
	M/Ekm8eJGb9ZPOadDPSYdPgzk8eXVdeYPd7vu8rm8XmTXABPFJdNSmpOZllqkb5dAlfG5ZuP
	2AquCle82tjI2sB4hb+LkZNDQsBE4sPl6WwQtpjEhXvrgWwuDiGBpYwSxx5fZYVwmpkk7jcu
	Ywep4hXQktg69SBQgoODRUBV4uTCLJAwm4CexL9Z28EGiQpESFxZM4cRolxQ4sfkeywgc0QE
	/rJIrLt3GCwhLBAssX1BI9SCl4wSt6duAUtwCnhL/FrTwAiygBlo6v2LWiBhZgF5ic1r3jJP
	YOSfhWTuLISqWUiqFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibmvOxiXHrM6xCjA
	wajEwzvhen2IEGtiWXFl7iFGCQ5mJRHeU9YNIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYZ7v6
	tp7deWP6h5gzAmonvZoSuEVNF8nOe/muwSvmhE9k8o7o7TXX7jNM3851S2nrUk8WyUnfNhky
	HnC/2yUiPvmwyN0L68tO/s64LXdH7ofeoRIxRcWDT9wT7aMMhStVWJ/U2ivMTJqhZmvTnDDb
	L7Cp5/3sx78Tf3z/v2Mz0wKZ87ZvVIOrlViKMxINtZiLihMBgc7/aZcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 03:19 AM, Andrew Morton wrote:
> On Wed, 3 Dec 2014 15:25:24 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Wed, 03 Dec 2014 15:41:21 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
>>
>>>
>>> Use the 'unsigned long' type for 'zero' variable to fix this.
>>> Changing type to 'unsigned long' shouldn't affect any other users
>>> of this variable.
>>>
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
>>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>>> ---
>>>  kernel/sysctl.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>>> index 15f2511..45c45c9 100644
>>> --- a/kernel/sysctl.c
>>> +++ b/kernel/sysctl.c
>>> @@ -120,7 +120,7 @@ static int sixty = 60;
>>>  
>>>  static int __maybe_unused neg_one = -1;
>>>  
>>> -static int zero;
>>> +static unsigned long zero;
>>>  static int __maybe_unused one = 1;
>>>  static int __maybe_unused two = 2;
>>>  static int __maybe_unused four = 4;
>>
>> Yeah, this is ghastly.
>>
>> Look at 
>>
>> 	{
>> 		.procname	= "numa_balancing",
>> 		.data		= NULL, /* filled in by handler */
>> 		.maxlen		= sizeof(unsigned int),
>> 		.mode		= 0644,
>> 		.proc_handler	= sysctl_numa_balancing,
>> 		.extra1		= &zero,
>> 		.extra2		= &one,
>> 	},
>>
>> Now extra1 points at a long and extra2 points at an int. 
>> sysctl_numa_balancing() calls proc_dointvec_minmax() and I think your
>> patch just broke big-endian 64-bit machines.  "sched_autogroup_enabled"
>> breaks as well.
> 
> Taking another look at this...
> 
> numa_balancing will continue to work on big-endian because of course
> zero is still zero when byteswapped.  But that's such a hack, isn't
> documented and doesn't work for "one", "sixty", etc.
> 

Yeah, I agree it's a bit hacky.

> I'm thinking a better fix here is to switch hugetlb_sysctl_handler to
> use `int's.  2^32 hugepages is enough for anybody.
> 

It's 8 petabytes for 2MB pages, so yeah should be enough.
Perhaps it also makes sense to change types for counters in 'struct hstate' from longs to ints.



> hugetlb_overcommit_handler() will need conversion also.
> 
> Perhaps auditing all the proc_doulongvec_minmax callsites is the way to
> attack this.
> 

I've looked through this yesterday and didn't found anything obviously wrong.
Though I could easily miss something.


