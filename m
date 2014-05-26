Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaEZFTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:19:01 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:47986 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZFS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140526041958.GV8554@dastard>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
	<CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
	<20140526000813.GS8554@dastard>
	<20140526011904.GT8554@dastard>
	<20140526041958.GV8554@dastard>
Date: Mon, 26 May 2014 08:18:59 +0300
Message-ID: <CALkh-HgGuGaR3rimNeCgRUexU1LgKMbSZ+WcPMmzD6UwtVC7pQ@mail.gmail.com>
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?= 
	<plamen.sisi@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-26 7:19 GMT+03:00 Dave Chinner <david@fromorbit.com>:
> On Mon, May 26, 2014 at 11:19:04AM +1000, Dave Chinner wrote:
>> On Mon, May 26, 2014 at 10:08:13AM +1000, Dave Chinner wrote:
>> > On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
>> > > On Mon, May 5, 2014 at 11:34 AM, Plamen Petrov <plamen.sisi@gmail.com> wrote:
>> > > >
>> > > > The story short: on systems with btrfs root I have a kernel .config with ext4,
>> > > > xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
>> > > > inserting some debug printks, I got this info from mount_block_root:
>> > > >
>> > > > ---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
>> > > > -----> Tried ext3, error code is -22.
>> > > > -----> Tried ext2, error code is -22.
>> > > > -----> Tried ext4, error code is -22.
>> > > > -----> Tried fuseblk, error code is -22.
>> > > > -----> Tried xfs, error code is -38.
>> > > > VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
>> > > > Please append a correct "root=" boot option; here are the available partitions:
>>
>> BTW, This is the original thread with lots of triage in it:
>>
>> http://www.spinics.net/lists/linux-btrfs/msg33455.html
>>
>> But that doesn't reach any conclusion. I suspect that the
>> change of btrfs init (from very early (@~1.8s into the boot) until a
>> few milliseconds before the root mount is changing the order in
>> which the filesystem type list is traversed by the mount, resulting
>> in XFS being used to probe the device before btrfs.
>
> On that point, on 3.15-rc6:
>
> $ tail -1 /proc/filesystems
>         btrfs
> $
>
>> Why XFS is seeing /dev/sda2 as containing an XFS filesystem is not
>> yet clear, but perhaps once you've dumped the the first sector of
>> the btrfs partition all will become clear....
>
> No need, I found the regression. Plamen, can you please try the
> patch below?
>

Yes, Dave. I applied your patch on top of linux 3.15-rc5. I tried the patch
you sent in a VM I used for tests.

With only your patch applied - the system boots up normally.

Thanks for the different perspectives, guys! Always a pleasure
communicating with you. After a month or so waiting - definetly worth it!

Thanks a lot!
-- 
Plamen Petrov
