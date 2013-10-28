Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3J1Qxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:53:55 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:52937 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab3J1Qxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <1382963296.992.108.camel@kjgkr>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
	<1382716919-23345-4-git-send-email-huajun.li.lee@gmail.com>
	<1382962607.992.104.camel@kjgkr>
	<1382963296.992.108.camel@kjgkr>
Date: Tue, 29 Oct 2013 00:53:53 +0800
Message-ID: <CA+v9cxYx35Q=PS4wB52JSWj75T9xg_VYp9PySujZNhPWxj9jAA@mail.gmail.com>
Subject: Re: [f2fs-dev 3/5] f2fs: Add a new function: f2fs_reserve_block()
From: Huajun Li <huajun.li.lee@gmail.com>
To: "jaegeuk.kim" <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

Thanks for your kindly review and comments.

On Mon, Oct 28, 2013 at 8:28 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> 2013-10-28 (월), 21:16 +0900, Jaegeuk Kim:
> Hi,
>
>>
>> 2013-10-26 (토), 00:01 +0800, Huajun Li:
>> > From: Huajun Li <huajun.li@intel.com>
>> >
>> > Add the function f2fs_reserve_block() to easily reserve new blocks.
>> >
>> > Signed-off-by: Huajun Li <huajun.li@intel.com>
>> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
>> > Signed-off-by: Weihong Xu <weihong.xu@intel.com>
>> > ---
>> >  fs/f2fs/data.c |   29 ++++++++++++++++++-----------
>> >  fs/f2fs/f2fs.h |    1 +
>> >  2 files changed, 19 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>> > index c8887d8..7b31911 100644
>> > --- a/fs/f2fs/data.c
>> > +++ b/fs/f2fs/data.c
>> > @@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
>> >     return 0;
>> >  }
>> >
>> > +int f2fs_reserve_block(struct inode *inode,
>> > +                  struct dnode_of_data *dn, pgoff_t index)
>>
>
> We don't need to get dnode_of_data from parameters, since it is
> used by this function only.

After calling f2fs_reserve_block(), we need dn.data_blkaddr to check
whether it is NEW_ADDR. So IMO, it's nice to keep this parameter.

>
>>
>> > +{
>> > +   int err;
>
> +        struct dnode_of_data dn;
>
>>
>> > +
>> > +   set_new_dnode(dn, inode, NULL, NULL, 0);
>> > +   err = get_dnode_of_data(dn, index, ALLOC_NODE);
>> > +   if (err)
>> > +           return err;
>> > +   if (dn->data_blkaddr == NULL_ADDR)
>> > +           err = reserve_new_block(dn);
>> > +
>> > +   f2fs_put_dnode(dn);
>> > +
>> > +   return err;
>> > +}
>> > +
>>
>
> --
> Jaegeuk Kim
> Samsung
>
