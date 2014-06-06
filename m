Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFFCDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 22:03:14 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:49976 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaFFCDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 22:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <53911FA6.1030505@kernel.dk>
References: <20140604103544.GA11350@dhcp-26-207.brq.redhat.com>
	<538F2AC2.1060904@kernel.dk>
	<20140605140127.GA22198@dhcp-26-207.brq.redhat.com>
	<53907895.8090102@kernel.dk>
	<CACVXFVMFjR5kqB9SQG-EiKMB3dC0O58_EhJZw2R2m7a9vUuH0A@mail.gmail.com>
	<5390A624.8020308@kernel.dk>
	<CACVXFVO-1shNB=tSpNBp_tpx+9imx5ycxfaSwofg-VeR_4S+MA@mail.gmail.com>
	<53911FA6.1030505@kernel.dk>
Date: Fri, 6 Jun 2014 10:03:12 +0800
Message-ID: <CACVXFVNNG8Kev6Ux=5vFAe1vHZfjayTngm8xGHO+yhMEiJHv8A@mail.gmail.com>
Subject: Re: blk-mq: bitmap tag: performance degradation?
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 9:55 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-06-05 17:33, Ming Lei wrote:
>>
>> On Fri, Jun 6, 2014 at 1:17 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 06/05/2014 08:16 AM, Ming Lei wrote:
>>>>
>>>> On Thu, Jun 5, 2014 at 10:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 2014-06-05 08:01, Alexander Gordeev wrote:
>>>>>>
>>>>>>
>>>>>> On Wed, Jun 04, 2014 at 08:18:42AM -0600, Jens Axboe wrote:
>>>>>>>
>>>>>>>
>>>>>>> A null_blk test is the absolute best case for percpu_ida, since
>>>>>>> there are enough tags and everything is localized. The above test is
>>>>>>> more useful for testing blk-mq than any real world application of
>>>>>>> the tagging.
>>>>>>>
>>>>>>> I've done considerable testing on both 2 and 4 socket (32 and 64
>>>>>>> CPUs) and bitmap tagging is better in a much wider range of
>>>>>>> applications. This includes even high tag depth devices like nvme,
>>>>>>> and more normal ranges like mtip32xx and scsi-mq setups.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Just for the record: bitmap tags on a 48 CPU box with NVMe device
>>>>>> indeed shows almost the same performance/cache rate as the stock
>>>>>> kernel.
>>>>>
>>>>>
>>>>>
>>>>> Thanks for confirming. It's one of the dangers of null_blk, it's not
>>>>> always
>>>>> a very accurate simulation of what a real device will do. I think it's
>>>>> mostly a completion side thing, would be great with a small device that
>>>>> supported msi-x and could be used as an irq trigger :-)
>>>>
>>>>
>>>> Maybe null_blk at IRQ_TIMER mode is more close to
>>>> a real device, and I guess the result may be different with
>>>> mode IRQ_NONE/IRQ_SOFTIRQ.
>>>
>>>
>>> It'd be closer in behavior, but the results might then be skewed by
>>> hitting the timer way too hard. And it'd be a general slowdown, again
>>> possibly skewing it. But I haven't tried with the timer completion, to
>>> see if that yields more accurate modelling for this test, so it might
>>> actually be a lot better.
>>
>>
>> My test on a 16core VM(host: 2 sockets, 16core):
>>
>> 1, bitmap tag allocation(3.15-rc7-next):
>> - softirq mode: 759K IOPS
>> - timer mode: 409K IOPS
>>
>> 2, percpu_ida allocation(3.15-rc7)
>> - softirq mode: 1116K IOPS
>> - timer mode: 411K IOPS
>
>
> It's hard to say if this is close, or whether we are just timer bound at
> that point.
>
> What other parameters did you load null_blk with (unmber of queues, queue
> depth)?

depth: 256, submit queues: 1

Thanks,
-- 
Ming Lei
