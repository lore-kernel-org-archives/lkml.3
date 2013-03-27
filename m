Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3C0A5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:57:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49898 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3C0A5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <1364343513.29882.7.camel@kjgkr>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
	<1364343513.29882.7.camel@kjgkr>
Date: Wed, 27 Mar 2013 09:57:46 +0900
Message-ID: <CAKYAXd9UQwGoLP9s3n-h2qdtpOFRbzTBVUkWUw2+XPEFo1k-Ew@mail.gmail.com>
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
> 2013-03-26 (화), 09:48 +0900, Namjae Jeon:
>> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > This patch removes data_version check flow during the fsync call.
>> > The original purpose for the use of data_version was to avoid writng
>> > inode
>> > pages redundantly by the fsync calls repeatedly.
>> Hi Jaegeuk.
>> > However, when user can modify file meta and then call fsync, we should
>> > not
>> > skip fsync procedure.
>> I have a question.
>> Which case does user can directly modify meta ? Recovery tool ?
>
> The meta means the inode information like atime, mtime, size, and so on,
> which can be modified by setattr() or something other vfs apis.
> Thanks,
I understood. Thanks for your explanation :)
One more,,
When inode state is  !(inode->i_state & I_DIRTY)), We don't need to skip ?

Thanks.
>
>>
>> Thanks.
>>
>> > So, let's remove this condition check and hope that user triggers in
>> > right
>> > manner.
>> >
>> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
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
