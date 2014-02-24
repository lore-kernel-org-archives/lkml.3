Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaBXBew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:34:52 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38281 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaBXBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:34:50 -0500
X-Greylist: delayed 760 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2014 20:34:50 EST
MIME-Version: 1.0
In-Reply-To: <20140224005710.GH4317@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
Date: Mon, 24 Feb 2014 10:34:49 +0900
Message-ID: <CAKYAXd83FtcoPc40FjAQ_-7uUfyY5bPZYKjzNLpUPFx=mtVJuA@mail.gmail.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
 for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dave Chinner <david@fromorbit.com>, mtk.manpages@gmail.com
Cc: viro@zeniv.linux.org.uk, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-24 9:57 GMT+09:00, Dave Chinner <david@fromorbit.com>:
> On Wed, Feb 19, 2014 at 01:37:16AM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch series is in response of the following post:
>> http://lwn.net/Articles/556136/
>> "ext4: introduce two new ioctls"
>>
>> Dave chinner suggested that truncate_block_range
>> (which was one of the ioctls name) should be an fallocate operation
>> and not any fs specific ioctl, hence we add this functionality to
>> fallocate.
>>
>> This patch series introduces new flag FALLOC_FL_COLLAPSE_RANGE for
>> fallocate
>> and implements it for XFS and Ext4.
>>
>> The semantics of this flag are following:
>> 1) It collapses the range lying between offset and length by removing any
>> data
>>    blocks which are present in this range and than updates all the
>> logical
>>    offsets of extents beyond "offset + len" to nullify the hole created
>> by
>>    removing blocks. In short, it does not leave a hole.
>> 2) It should be used exclusively. No other fallocate flag in combination.
>> 3) Offset and length supplied to fallocate should be fs block size
>> aligned
>>    in case of xfs and ext4.
>> 4) Collaspe range does not work beyond i_size.
>>
>> This new functionality of collapsing range could be used by media editing
>> tools
>> which does non linear editing to quickly purge and edit parts of a media
>> file.
>> This will immensely improve the performance of these operations.
>> The limitation of fs block size aligned offsets can be easily handled
>> by media codecs which are encapsulated in a conatiner as they have to
>> just change the offset to next keyframe value to match the proper
>> alignment.
>>
>> Namjae Jeon (10):
>>   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
>>   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>
> I've pushed these to the following branch:
>
> 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
>
> And so they'll be in tomorrow's linux-next tree.
Okay.
>
>>   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>
> I've left this one alone for the ext4 guys to sort out.
I will try to follow up continously.
>
>>   xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>
> That's already in a current xfstests tree.
Okay.
>
>>   xfstest: shared/001: Standard collapse range tests
>>   xfstest: shared/002: Delayed allocation collapse range
>>   xfstest: shared/003: Multi collapse range tests
>>   xfstest: shared/004: Delayed allocation multi collapse
>>   xfstest: shared/005: Test multiple fallocate collapse
>
> These are now in the xfstests git tree.
Okay.
>
>>   manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate
>
> And Michael will need to review and commit that to the kernel
> manpages tree.
Okay,
Hi Micheal.
Could you please review manpage patch ?

Thanks :)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
