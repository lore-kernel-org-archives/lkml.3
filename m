Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaDHOmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:42:55 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48994 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaDHOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:42:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140408005417.GI27017@dastard>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
	<20140408005417.GI27017@dastard>
Date: Tue, 8 Apr 2014 23:42:47 +0900
Message-ID: <CAKYAXd_egdR5997MPgd5eRuYRsYFFbMvYEaYsD6Dsnp=YLVHPw@mail.gmail.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-08 9:54 GMT+09:00, Dave Chinner <david@fromorbit.com>:
> On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> FALLOC_FL_INSERT_RANGE was mentioned as the opposite command of collapse
>> range from discussion between Hugh Dickins and Dave Chinner.
>>
>> In continuation of the work of making the process of non linear editing
>> of
>> media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
>> for fallocate.
>>
>> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE
>> flag.
>> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out
>> space
>> in between the file within the range specified by offset and len. User
>> can
>> write new data in this space. e.g. ads.
>> Like collapse range, currently we have the limitation that offset and len
>> should be block size aligned for both XFS and Ext4.
>>
>> The semantics of the flag are :
>> 1) It allocates new zeroed out on disk space of len bytes starting
>>    at offset byte without overwriting any existing data. All the data
>> blocks
>>    from offset to EOF are shifted towards right to make space for
>> inserting
>>    new blocks
>> 2) It should be used exclusively. No other fallocate flag in combination.
>> 3) Offset and length supplied to fallocate should be fs block size
>> aligned
>>    in case of xfs and ext4.
>> 4) Insert range does not work for the case when offset is
>> overlapping/beyond
>>    i_size. If the user wants to allocate space at the end of file they
>> are
>>    advised to use either ftruncate(2) or fallocate(2) with mode 0.
>> 5) It increses the size of file by len bytes.
>>
>> Namjae Jeon (3):
>>  fs: Add FALLOC_FL_INSERT_RANGE flags for fallocate
>>  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>>  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
>>  TODO : xfsprog: xfsio: Add support FALLOC_FL_INSERT_RANGE for fallocate
>>  TODO : xfstests: Add insert range testcase
>
> Namjae, what's your proposed timeframe on getting the xfs_io and tes
> cases sorted out? I'm just trying to plan ahead for the next couple
> of months (i.e. the 3.16 merge cycle), so some indication of whether
> I can expect this to be complete and ready for merge within that
> timeframe would be helpful to me.
Hi. Dave.
I will post the next version's patch-set with xfs_io and xfstests next week.
Yes, I think that it can be complete before opening 3.6 merge window.
And sorry for late response and work... Currently I can not do it full time.
But will do the best for the aim that insert range would be merged in 3.6.
>
> FWIW, it would be really nice if you could add support for fsx and
> fsstress for this as well as adding corner case tests. :)
I can, I will include these jobs on next version. :)

Thanks!
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
