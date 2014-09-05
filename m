Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaIEHFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:05:49 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61081 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIEHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:05:46 -0400
Message-ID: <54096159.6060602@gmail.com>
Date: Fri, 05 Sep 2014 09:08:09 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Peter Kieser <peter@kieser.ca>, kmo@daterainc.com,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
References: <1398981150-27765-1-git-send-email-sp@daterainc.com> <CA+waHKU1Kaz4Bf=AogB_bXHLZ03tOYp2N5LL=JYH--Y3Yq4qow@mail.gmail.com> <537112A5.6040709@kieser.ca> <53747499.3070000@gmail.com> <5374F9D2.8020209@kernel.dk> <538C8539.1060607@gmail.com> <53D20795.60404@gmail.com>
In-Reply-To: <53D20795.60404@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 09:30 AM, Francis Moreau wrote:
> Hi,
> 
> On 06/02/2014 04:07 PM, Francis Moreau wrote:
>> Hello,
>>
>> On 05/15/2014 07:30 PM, Jens Axboe wrote:
>>> On 05/15/2014 02:02 AM, Francis Moreau wrote:
>>>> Hello Jens,
>>>>
>>>> On 05/12/2014 08:27 PM, Peter Kieser wrote:
>>>>>
>>>>> On 2014-05-05 3:30 PM, Nikolay Amiantov wrote:
>>>>>> 2014-05-02 1:52 GMT+04:00 Slava Pestov <sp@datera.io>:
>>>>>>> There were two issues here:
>>>>>>>
>>>>>>> - writeback thread did not start until the device first became dirty
>>>>>>> - writeback thread used uninterruptible sleep once running
>>>>>>>
>>>>>>> Without this patch I see kernel warnings printed and a load average of
>>>>>>> 1.52 after booting my test VM. With this patch the warnings are gone and
>>>>>>> the load average is near 0.00 as expected.
>>>>>> I've tried this patch and it has indeed fixed [1]! Thanks!
>>>>>>
>>>>>> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=69471
>>>>>
>>>>> Kent,
>>>>>
>>>>> Could you please review this patch, and have it pushed upstream?
>>>>>
>>>>
>>>> Would it be possible to merge this patch directly before 3.15 is being
>>>> released since kent don't seem to care about bugs in bcache or maybe he
>>>> does but very selectively ?
>>>>
>>>> Also it would be great that stable trees will be fixed.
>>>>
>>>> Eventually I would suggest to mark bcache as an experimental thing since
>>>> it's really not ready for production, just take a look at the bcache
>>>> mailing list to see why. At least people won't be disappointed when
>>>> they'll use bcache and see ton of koops.
>>>
>>> I'd really like to get Kent to weigh in on this. Sometimes it appears
>>> straightforward to switch from uninterruptible to interruptible sleep,
>>> but then signals get in the way.
>>>
>>
>> Any progress ?
>>
> 
> still present on 3.15.5-2-ARCH :-/
> 

still present on 3.14.17 :-/

