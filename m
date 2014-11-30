Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaK3UzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:55:08 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:58339 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaK3UzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:55:06 -0500
MIME-Version: 1.0
In-Reply-To: <547B48F3.6020909@nod.at>
References: <1417258323.9558.3.camel@gmail.com>
	<CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>
	<CAAzz28gHzPSC+VsSeq56oWj-KByCqK0oqeG3N4HM3D1iX_z6uQ@mail.gmail.com>
	<1417365364.4806.1.camel@gmail.com>
	<547B48F3.6020909@nod.at>
Date: Sun, 30 Nov 2014 15:55:03 -0500
Message-ID: <CAAzz28j0kTWaqnyAXR-1ASmzqdyp5hjYx1WmRg3_CN62Bt577w@mail.gmail.com>
Subject: Re: Crash when copying from broken external hdd
From: Laurence Oberman <oberman.l@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Simon Danner <danner.simon@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BUG_ON is taken because
blk_queued_rq(req)) returns true which means the request->queuelist is
empty, i.e no more entries by the time the request is dereferenced

Can I get the messages file entries (last 100 lines) just prior to the
panic, not the whole file.
If its large attach  .gz and email to me.

Thanks

On Sun, Nov 30, 2014 at 11:42 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 30.11.2014 um 17:36 schrieb Simon Danner:
>> Hi,
>> here the two screenshots i could take, from 3.17.4 and 3.18 git.
>
> You're hitting BUG_ON(blk_queued_rq(req)); in blk_finish_request()
>
> Thanks,
> //richard
>
>> Thanks
>> Simon
>>
>> On Sun, 2014-11-30 at 10:58 -0500, Laurence Oberman wrote:
>>> I need more of the stack if you have it, the screenshot is not attached.
>>> Thanks
>>> Laurence
>>>
>>> On Sun, Nov 30, 2014 at 6:11 AM, Richard Weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> On Sat, Nov 29, 2014 at 11:52 AM, Simon Danner <danner.simon@gmail.com> wrote:
>>>>> Hello,
>>>>> i get the following crash after i try to copy files from a broken
>>>>> external hdd to another external hdd.
>>>>> It happens after a few minutes, with latest git and 3.17.4 from Arch.
>>>>> Attached screenshot is from latest mainline git.
>>>>>
>>>>> i hope this can be fixed somehow,
>>>>> Regards Simon Danner
>>>>
>>>> Can you decode scsi_requed_end+0x122?
>>>> CC'ing block and scsi folks.
>>>>
>>>> --
>>>> Thanks,
>>>> //richard
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
