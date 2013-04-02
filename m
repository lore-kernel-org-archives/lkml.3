Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3DBPlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:41:42 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41241 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3DBPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <1364884045.3301.18.camel@slavad-ubuntu>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
	<254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
	<5159EC3D.2020501@gmail.com>
	<1364884045.3301.18.camel@slavad-ubuntu>
Date: Tue, 2 Apr 2013 19:41:37 +0400
Message-ID: <CAMo8Bf+83t3ML_Ctr4V-pVL7Meei=pdOeC5cgtrPJB12tOcGtA@mail.gmail.com>
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt
 0" on 3.8
From: Max Filippov <jcmvbkbc@gmail.com>
To: slava@dubeyko.com
Cc: LKML <linux-kernel@vger.kernel.org>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 10:27 AM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> On Tue, 2013-04-02 at 00:21 +0400, Max Filippov wrote:

[...]

>> # cat /proc/partitions
>> major minor  #blocks  name
>>
>>  179        0    7782400 mmcblk0
>>  179        1      40131 mmcblk0p1
>>  179        2      32130 mmcblk0p2
>>  179        3    5685248 mmcblk0p3
>>
>
> As I see, you have several partition on your SD-card. How did it
> prepared?

I made it with fdisk, just as with any other block device.

>> strace output is the following:
>>
> [snip]
>> write(1, "Info: sector size = 512\n", 24) = 24
>> write(1, "Info: total sectors = 11370496 ("..., 45) = 45
>> write(1, "Info: zone aligned segment0 blka"..., 41) = 41
>> fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(179, 3), ...}) = 0
>> ioctl(3, BLKDISCARD
>
> As I understand, the BLKDISCARD ioctl (to pre-discard all blocks on an
> ssd, or a thinly-provisioned storage device) is a visible reason of the
> issue. Unfortunately, as I see, mkfs.f2fs doesn't support option to
> format partition without blocks discard step.
>
> So, I think that it needs to investigate issue in the direction of
> BLKDISCARD code on the kernel side. It makes sense to debug
> f2fs_trim_device() method of mkfs.f2fs utility too. But I can't see
> anything strange in this function at a glance.

Ok, I'll try to find what has changed in that ioctl handler since 3.6.

-- 
Thanks.
-- Max
