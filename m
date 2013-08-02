Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3HBB2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:28:14 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33127 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3HBB2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <51F9D407.8040703@cn.fujitsu.com>
References: <1375281193-15560-1-git-send-email-linkinjeon@gmail.com>
	<51F9D407.8040703@cn.fujitsu.com>
Date: Fri, 2 Aug 2013 10:28:12 +0900
Message-ID: <CAKYAXd9bcV3OMvrWu1hkPuriz+2wc--wLf6N7pLDKX2+Y2Pqrw@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add sysfs entries to select the gc policy
From: Namjae Jeon <linkinjeon@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/1, Gu Zheng <guz.fnst@cn.fujitsu.com>:
> Hi Jeon,
>
> On 07/31/2013 10:33 PM, Namjae Jeon wrote:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add sysfs entries namely gc_long_idle and gc_short_idle to control the
>> gc policy. Where long idle corresponds to selecting a cost benefit
>> approach,
>> while short idle corresponds to selecting a greedy approach to garbage
>> collection. The selection is mutually exclusive one approach will work at
>> any point.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> ---
>>  Documentation/ABI/testing/sysfs-fs-f2fs |   12 +++++++
>>  Documentation/filesystems/f2fs.txt      |    8 +++++
>>  fs/f2fs/gc.c                            |   22 ++++++++++--
>>  fs/f2fs/gc.h                            |    4 +++
>>  fs/f2fs/super.c                         |   59
>> +++++++++++++++++++++++++++++--
>>  5 files changed, 99 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs
>> b/Documentation/ABI/testing/sysfs-fs-f2fs
>> index 5f44095..96b62ea 100644
>> --- a/Documentation/ABI/testing/sysfs-fs-f2fs
>> +++ b/Documentation/ABI/testing/sysfs-fs-f2fs
>> @@ -19,4 +19,16 @@ Description:
>>  		 Controls the default sleep time for gc_thread. Time
>>  		 is in milliseconds.
>>
>> +What:		/sys/fs/f2fs/<disk>/gc_long_idle
>> +Date:		July 2013
>> +Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
>> +Description:
>> +		 Controls the selection of gc policy. long_idle is used
>> +		 to select the cost benefit approach for garbage collection.
>>
>> +What:		/sys/fs/f2fs/<disk>/gc_short_idle
>> +Date:		July 2013
>> +Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
>> +Description:
>> +		 Controls the selection of gc policy. short_idle is used
>> +		 to select the greedy approach for garbage collection.
>> diff --git a/Documentation/filesystems/f2fs.txt
>> b/Documentation/filesystems/f2fs.txt
>> index 2e9e873..06dd5d7 100644
>> --- a/Documentation/filesystems/f2fs.txt
>> +++ b/Documentation/filesystems/f2fs.txt
>> @@ -158,6 +158,14 @@ Files in /sys/fs/f2fs/<devname>
>>                                time for the garbage collection thread.
>> Time is
>>                                in milliseconds.
>>
>> + gc_long_idle                 This parameter controls the selection of
>> cost
>> +                              benefit approach for garbage collectoin.
>> Writing
>> +                              1 to this file will select the cost benefit
>> policy.
>> +
>> + gc_short_idle                This parameter controls the selection of
>> greedy
>> +                              approach for the garbage collection.
>> Writing 1
>> +                              to this file will select the greedy
>> policy.
>
Hi Gu.
> Why introduce two opposite attributes? It'll cause some confusion condition
> if we
> double enable/disable them.
Yes, it  seem possible in that you're talking.
Okay, I will make one gc_idle and we can use long idle and short idle
accoding to setting values.

Thanks for review!

>
>> +
>>
>>
