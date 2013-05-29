Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3E2ABx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:01:53 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47599 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2ABu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <1369704867.10521.46.camel@kjgkr>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
	<1369619214.10521.25.camel@kjgkr>
	<CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
	<1369704867.10521.46.camel@kjgkr>
Date: Wed, 29 May 2013 09:01:49 +0900
Message-ID: <CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/28, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
> 2013-05-27 (월), 13:45 +0900, Namjae Jeon:
>> 2013/5/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > Hi Namjae,
>> Hi Jaegeuk.
>>
>> First, Thanks for your interest.
>> >
>> > This is an interesting functionality.
>> > Could you describe why and when we need to do this?
>> > What are pros and cons?
>> > How can we use this?
>> As the default size of the F2FS parameter can vary as per the storage
>> size, so we can figure out the default values for Garbage collection
>> on each device.
>> It will be good if we can provide an interface which helps in tunning
>> these timing parameters to optimize the behavior of GC thread.
>
> Agreed.
>
>>
>> As you know, we can see performance dropping suddenly by GC thread. GC
>> thread is working more roughly for big size disk. And on other hand,
>> it is more work hard for very small partition.
>>
>> And If App didn't access f2fs partition for a while. We can use this
>> time to make possible valid blocks using foregound gc thread working.
>> So we should need gc thread fg start and stop functionality.
>> We will describe how to use it and more detail in patch changelog(v2).
>> >
>> > IMO, when users try to control IO latencies, it seems that they can
>> > trigger such the explicit GCs, but in order to do that, they also need
>> > to know the status of current f2fs in more precisely. Does the debugfs
>> > show it enoughly?
>> First important thing before running the GC thread forecefully from
>> the user level ‘sysfs’ is to have diagnostic values of the FLASH
>> partition. So, we are trying to figure out how we can check the stats
>> regarding running the GC thread.
>>
>> I have thought more after getting your reply.
>> f2fs_cleaner(a tentative name) is that provide the following several
>> options to control gc thread.
>> 1. start forground gc thread to clean all invalid blocks.
>> 2. stop number 1(fg) working.
>> 3. set new tunning parameter (min/max/no_gc).
>> 4. get status of current f2fs.
>> We will provide user level util in f2fs tools and sysfs at the same time.
>> It is useful if the console level user/App user can change them easily.
>>
>> >
>> > Afterwards, it is worth to add some information to
>> > Document/filesystems/f2fs.txt.
>> Yes, It will be included in next series patches.
>> How do you think ? If you agree my suggestion, I will start to work
>> the above jobs.
Hi. Jaegeuk.
>
> As I described, basically I agreed that this kind of interfaces and user
> apps are definitely beneficial to the f2fs users.
>
> But wrt design and implementation of new interfaces, we'd better discuss
> how to use them in more detail and what information should be needed for
> user-made cleaner.
> After then, we'd better start to design the interfaces as well as user
> scenarios clearly.
Okay. I agree.

>
> IMO, the following issues should be addressed.
> - how to know system idle time by users?
e.g. When playing PVR function, In case of DTV, App try to read data
from filesystem of usb device.
now that, user app will never access flash rw partition and don't need
to access there.
I think that we can cleverly use such time to avoid or make slowly
come in the possible performance regression later.

> - any priority scheme for cleaning?
Could you plz tell me a little more detail ?

> - what status of current f2fs?
I think that we can get this information how many victim section and
segment is possible to reclaim in sysfs.
It will be easily interpreted by the user and it allows the user the
freedom to check itself if really running GC is useful
and user can decide to run cleaner at timing they want.

> - how about supporting that f2fs controls gc times dynamically instead
> of the user decision?
Yes, I thought such idea before. It might be useful if gc thread can
dynamically control own gc times with different partition size and
available size.
But I think there is a limitation that f2fs don't predict when user access f2fs.
So I think that user level controller surely is needed.
Ah,, And It will be also useful if f2fs is mounted with background_gc_off.

Let me know your opinion~.

Thanks:)
>
> Thanks,
>
>>
>> Let me know your opinion.
>>
>> Thanks.
>> >
>> > Thanks,
>> >
>
> --
> Jaegeuk Kim
> Samsung
>
