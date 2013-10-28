Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3J1PJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:09:41 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33492 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3J1PJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAMpEsFHO5yrwxK9q=hQtOxwC=0_p4BznBGjvomPgFZogwXABRA@mail.gmail.com>
References: <20131019110539.GA25167@gmail.com>
	<cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
	<CAL1ERfPD7zhmuO6ZuwUcJzVshJ3vqQKAman_x27rTPaur4eEAw@mail.gmail.com>
	<CAMpEsFHO5yrwxK9q=hQtOxwC=0_p4BznBGjvomPgFZogwXABRA@mail.gmail.com>
Date: Mon, 28 Oct 2013 23:09:36 +0800
Message-ID: <CAL1ERfOEurbxjy1r8fqGJBXT2Go+7BRM3u6Cg4XfCSdtjFzTYQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] Staging: zram: Fix access of NULL pointer
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel <opw-kernel@googlegroups.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:33 PM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
>
>
>
> On Mon, Oct 28, 2013 at 7:15 PM, Weijie Yang <weijie.yang.kh@gmail.com>
> wrote:
>>
>> On Mon, Oct 28, 2013 at 8:21 PM, Rashika Kheria
>> <rashika.kheria@gmail.com> wrote:
>> > This patch fixes the bug in reset_store caused by accessing NULL
>> > pointer.
>> > Hence, It introduces a check for bdev. It also removes unnecessary check
>> > of bdev for fsync_bdev().
>> >
>> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>> > ---
>> >
>> > This revision fixes the following issues of the previous revision-
>> > Seperating patches into Bug fix and Smatch fix
>> >
>> >  drivers/staging/zram/zram_drv.c |    6 ++++--
>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/staging/zram/zram_drv.c
>> > b/drivers/staging/zram/zram_drv.c
>> > index 2c4ed52..d640a8f 100644
>> > --- a/drivers/staging/zram/zram_drv.c
>> > +++ b/drivers/staging/zram/zram_drv.c
>> > @@ -648,6 +648,9 @@ static ssize_t reset_store(struct device *dev,
>> >         zram = dev_to_zram(dev);
>> >         bdev = bdget_disk(zram->disk, 0);
>> >
>> > +       if (!bdev)
>> > +               return -EBUSY;
>> > +
>>
>> I am not sure how does it happen. Would you please make it clear to me?
>>
>
> Hi Weijie,
>
> The bdev gets its value from bdget_disk() which could fail when memory is
> less available and hence bdev can be NULL.
>
> If this check is not introduced then we might reference NULL pointer in the
> later part of the code.

I see. Thanks!

> I hope I am clear.
>
> Thanks,
>
> --
> Rashika Kheria
> B.Tech CSE
> IIIT Hyderabad
