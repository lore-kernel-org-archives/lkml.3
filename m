Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaB0ED4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:03:56 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50011 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaB0EDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:03:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140226164827.GB11452@thunk.org>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
	<20140222170930.GE26637@thunk.org>
	<CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
	<20140226164827.GB11452@thunk.org>
Date: Thu, 27 Feb 2014 13:03:53 +0900
Message-ID: <CAKYAXd_4-BUiRMLfZ97vToSb4xuRj0zz=uvUc-w3cjcs3wM85g@mail.gmail.com>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
        david@fromorbit.com, bpm@sgi.com, adilger.kernel@dilger.ca,
        jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-27 1:48 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> On Mon, Feb 24, 2014 at 10:22:10AM +0900, Namjae Jeon wrote:
>> >> +	ret = ext4_es_remove_extent(inode, punch_start,
>> >> +				    EXT_MAX_BLOCKS - punch_start - 1);
>> >> +	if (ret) {
>> >> +		up_write(&EXT4_I(inode)->i_data_sem);
>> >> +		goto out_stop;
>> >> +	}
>> >
>> > Doing this at first is probably a bad idea; you should do this at the
>> > end, and then completely invalidate the es cache for that inode.  That
>> > way, the right thing happens if you get an error in the middle
>> > releasing the boxes and shifting the extents:
>> Okay, I see.
>
> Actually, thinking about this some more, we do want to do this first,
> since if we error out, we do need to make sure the extent cache is
> flushed.
Okay.

>
>> If there is error in the middle of extent shifting, the hole will
>> present between the last shifted extent and the extent at which error
>> happen so this will be consistent state.
>> IMHO even if there is error in between the shift, filesystem will be
>> in consistent state.
>> Am I missing something?
>
> No, I was wrong about that; you're right.  The file will be in an
> inconsistent statement, which will probably be highly confusing for
> the application, but the file system will be fine.
>
> So I withdraw my complaints.  I'll do a bit more testing, but so far
> the patch looks fine to me.  Thanks for your reply and your work!
Thanks for your review! I will fix these include Hugh's review points.
>
> 					- Ted
>
