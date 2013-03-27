Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3C0B26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:28:58 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39952 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3C0B24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:28:56 -0400
MIME-Version: 1.0
In-Reply-To: <1364347128.29882.12.camel@kjgkr>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
	<1364343513.29882.7.camel@kjgkr>
	<CAKYAXd9UQwGoLP9s3n-h2qdtpOFRbzTBVUkWUw2+XPEFo1k-Ew@mail.gmail.com>
	<1364347128.29882.12.camel@kjgkr>
Date: Wed, 27 Mar 2013 10:28:56 +0900
Message-ID: <CAKYAXd-R7+VxmzKBUdpBx_VooQDDs1cMDHGQqETzCYxvdModaA@mail.gmail.com>
Subject: Re: [PATCH 2/4] f2fs: do not skip writing file meta during fsync
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-27 (수), 09:57 +0900, Namjae Jeon:
>> 2013/3/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > 2013-03-26 (화), 09:48 +0900, Namjae Jeon:
>> >> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> >> > This patch removes data_version check flow during the fsync call.
>> >> > The original purpose for the use of data_version was to avoid writng
>> >> > inode
>> >> > pages redundantly by the fsync calls repeatedly.
>> >> Hi Jaegeuk.
>> >> > However, when user can modify file meta and then call fsync, we
>> >> > should
>> >> > not
>> >> > skip fsync procedure.
>> >> I have a question.
>> >> Which case does user can directly modify meta ? Recovery tool ?
>> >
>> > The meta means the inode information like atime, mtime, size, and so
>> > on,
>> > which can be modified by setattr() or something other vfs apis.
>> > Thanks,
>> I understood. Thanks for your explanation :)
>> One more,,
>> When inode state is  !(inode->i_state & I_DIRTY)), We don't need to skip
>> ?
>
> Even though fsync writes no data and the inode is clean, we should mark
> the inode to recover after power-off-recovery.
> Any data and its inode can be written to the disk clearly before fsync
> was called.
Okay, Clear.
Thanks Jaegeuk!

> Thanks,
>
>>
>> Thanks.
>> >
>> >>
>> >> Thanks.
>> >>
>> >> > So, let's remove this condition check and hope that user triggers in
>> >> > right
>> >> > manner.
>> >> >
>> >> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe
>> >> linux-kernel"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> Please read the FAQ at  http://www.tux.org/lkml/
>> >
>> > --
>> > Jaegeuk Kim
>> > Samsung
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Jaegeuk Kim
> Samsung
>
