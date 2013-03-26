Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab3CZAo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:44:27 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:57144 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab3CZAo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <1364197791.29882.5.camel@kjgkr>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd-999ACB+QNpOYXj=3WmH2OGYdrR9hpUn1WtpRCOJ8qiA@mail.gmail.com>
	<1364197791.29882.5.camel@kjgkr>
Date: Tue, 26 Mar 2013 09:44:25 +0900
Message-ID: <CAKYAXd9nFeTW3FbYMQOx3WB0Y2+dv9PSqo0ooGtvwZtcX=Mbxw@mail.gmail.com>
Subject: Re: [PATCH 1/4] f2fs: fix the recovery flow to handle errors correctly
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-25 (월), 15:30 +0900, Namjae Jeon:
>> 2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > We should handle errors during the recovery flow correctly.
>> > For example, if we get -ENOMEM, we should report a mount failure instead
>> > of
>> > conducting the remained mount procedure.
>> >
>> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>> > ---
>> >  fs/f2fs/f2fs.h     |  2 +-
>> >  fs/f2fs/recovery.c | 46 ++++++++++++++++++++++++++++------------------
>> >  fs/f2fs/super.c    |  9 +++++++--
>> >  3 files changed, 36 insertions(+), 21 deletions(-)
>> >
>> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> > index 5bb87e0..109e12d 100644
>> > --- a/fs/f2fs/f2fs.h
>> > +++ b/fs/f2fs/f2fs.h
>> > @@ -1027,7 +1027,7 @@ void destroy_gc_caches(void);
>> >  /*
>> >   * recovery.c
>> >   */
>> > -void recover_fsync_data(struct f2fs_sb_info *);
>> > +int recover_fsync_data(struct f2fs_sb_info *);
>> >  bool space_for_roll_forward(struct f2fs_sb_info *);
>> >
>> >  /*
>> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
>> > index 2d86eb2..61bdaa7 100644
>> > --- a/fs/f2fs/recovery.c
>> > +++ b/fs/f2fs/recovery.c
>> > @@ -118,10 +118,8 @@ static int find_fsync_dnodes(struct f2fs_sb_info
>> > *sbi,
>> > struct list_head *head)
>> >
>> >  		lock_page(page);
>> >
>> Hi Jaegeuk.
>> I have a question.
>> > -		if (cp_ver != cpver_of_node(page)) {
>> > -			err = -EINVAL;
>> > +		if (cp_ver != cpver_of_node(page))
>> >  			goto unlock_out;
>> > -		}
>> err = 0 is initialized to zero in the start of function
>> Why have you remove err = -EINVAL; code when mismatching cp_ver ?
>
> This ending condition is used to find the latest node pages that we have
> to recover, not to detect an error to exit the recovery routine.
> For example, the error conditions include -ENOMEM or -EIO, something
> like such the obvious errors.
> Thanks,
Yes, Right. It does make sense.
Thanks for explanation :)

You can add:
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
>
>>
>> Thanks.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Jaegeuk Kim
> Samsung
>
