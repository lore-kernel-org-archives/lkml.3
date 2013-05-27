Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3E0Ep5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 00:45:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35998 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3E0Epz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 00:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <1369619214.10521.25.camel@kjgkr>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
	<1369619214.10521.25.camel@kjgkr>
Date: Mon, 27 May 2013 13:45:55 +0900
Message-ID: <CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
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

2013/5/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi Namjae,
Hi Jaegeuk.

First, Thanks for your interest.
>
> This is an interesting functionality.
> Could you describe why and when we need to do this?
> What are pros and cons?
> How can we use this?
As the default size of the F2FS parameter can vary as per the storage
size, so we can figure out the default values for Garbage collection
on each device.
It will be good if we can provide an interface which helps in tunning
these timing parameters to optimize the behavior of GC thread.

As you know, we can see performance dropping suddenly by GC thread. GC
thread is working more roughly for big size disk. And on other hand,
it is more work hard for very small partition.

And If App didn't access f2fs partition for a while. We can use this
time to make possible valid blocks using foregound gc thread working.
So we should need gc thread fg start and stop functionality.
We will describe how to use it and more detail in patch changelog(v2).

>
> IMO, when users try to control IO latencies, it seems that they can
> trigger such the explicit GCs, but in order to do that, they also need
> to know the status of current f2fs in more precisely. Does the debugfs
> show it enoughly?
First important thing before running the GC thread forecefully from
the user level ‘sysfs’ is to have diagnostic values of the FLASH
partition. So, we are trying to figure out how we can check the stats
regarding running the GC thread.

I have thought more after getting your reply.
f2fs_cleaner(a tentative name) is that provide the following several
options to control gc thread.
1. start forground gc thread to clean all invalid blocks.
2. stop number 1(fg) working.
3. set new tunning parameter (min/max/no_gc).
4. get status of current f2fs.

We will provide user level util in f2fs tools and sysfs at the same time.
It is useful if the console level user/App user can change them easily.

>
> Afterwards, it is worth to add some information to
> Document/filesystems/f2fs.txt.
Yes, It will be included in next series patches.
How do you think ? If you agree my suggestion, I will start to work
the above jobs.

Let me know your opinion.

Thanks.
>
> Thanks,
>
