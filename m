Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3FDRnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:43:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7601 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab3FDRnH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:43:07 -0400
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2013 13:43:07 EDT
From: Dan Williams <djbw@fb.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jon Mason <jon.mason@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmatest: add ability to disable pq and xor
Thread-Topic: [PATCH] dmatest: add ability to disable pq and xor
Thread-Index: AQHOUyeQns6rsZMc00mjsAAclKAowZkffu0AgAW0jgCAAITbAIAALpCA
Date: Tue, 4 Jun 2013 17:11:51 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E491725F227@PRN-MBX01-3.TheFacebook.com>
In-Reply-To: <CAHp75VdgKDx8vhTcUD5sBLd7aB=39SFxi-ayioZqE6o_AtZkxA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.4.130416
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2027EFD21CFD0F42A37253EC3145C91A@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-04_06:2013-06-04,2013-06-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/4/13 12:25 AM, "Andy Shevchenko" <andy.shevchenko@gmail.com> wrote:

>On Tue, Jun 4, 2013 at 2:29 AM, Jon Mason <jon.mason@intel.com> wrote:
>> On Fri, May 31, 2013 at 11:22:10AM +0300, Andy Shevchenko wrote:
>>> On Fri, May 17, 2013 at 8:54 PM, Jon Mason <jon.mason@intel.com> wrote:
>>> > dmatest would create a thread to stress XOR and PQ, if the
>>>capability is
>>> > present in the hardware.  Add the ability to disable XOR and PQ by
>>> > disabling it if *_sources are set to zero.
>>>
>>> Sorry, didn't comment this earlier.
>>>
>>> Those threads are independent including MEMCPY stuff.
>>> I think it's better to have one additional parameter let's say
>>> type_of_test where you can set
>>> 1 for MEMCPY
>>> 2 for XOR
>>> 4 for PQ
>>>
>>> Share this parameter via debugfs and use 0x07 as default value.
>>> I doubt we need this as a module parameter.
>>
>> This is using the existing module parameter, so there is nothing new
>> added.
>
>That's why it's a bit confusing. User can more easily forget the
>'magic' numbers. And I see no reason to prevent user to enter 0 as a
>number of sources.

Well, source counts less than 2 are invalid for these operations, but that
is besides the point.

>Moreover, your patch doesn't cover the case when user doesn't want to
>run MEMCPY thread.

Yes, this is what I wanted to point out.  If we're adding per operation
type selection, might as well enable memcpy to be controlled too.
Especially if we just use a bitmap_and() with the dma_cap_mask() to pick
which tests to run.  Might also encourage some slave-op test types to be
added as well.

>
>>  Since the testing is started immediately upon module
>> insertion,
>
>It used to be so, but nowadays it's true only when dmatest is compiled in.
>If someone wants to compile in that module they probably want to run
>stress tests, where XOR and PQ might be useful.

...and they would want the test selection to be specified on the kernel
command line.  At least that's how I used compiled in dmatest in the past.

>
>> there needs to be a way to prevent it from ever starting.
>
>My opinion I already shared, new node under debugfs. There is might be
>a good reason to add a new module parameter as well.

I'm not seeing why debugfs is helpful here.  Just make it a module
parameter that calls a routine to setup the bit mask.

--
Dan

