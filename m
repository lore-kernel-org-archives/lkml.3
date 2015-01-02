Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbABRXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:23:33 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42227 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbABRXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:23:31 -0500
Message-ID: <54A6D40E.705@gmail.com>
Date: Sat, 03 Jan 2015 02:23:26 +0900
From: Seunghun Lee <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
References: <1420126692-9552-1-git-send-email-waydi1@gmail.com> <CA+icZUWj+raXW8zBr7gmYe36EA9wuq4xN_3pC+mhhV+qiOJV7g@mail.gmail.com>
In-Reply-To: <CA+icZUWj+raXW8zBr7gmYe36EA9wuq4xN_3pC+mhhV+qiOJV7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/02/2015 03:33 AM, Sedat Dilek wrote:
> On Thu, Jan 1, 2015 at 4:38 PM, Seunghun Lee <waydi1@gmail.com> wrote:
>> Overlayfs should be mounted read-only when upper fs is r/o or nonexistend.
>> But now it can be remounted read-write and this can causes kernel panic.
>> So we should prevent read-write remount when the above situation.
>>
> Cannot say much to the code, but you have some typos in your commit-message.
> Here some corrections... wording, style etc.
>
> ...when upper-fs (with a dash) is read-only (if you write read-write
> below) or nonexisten*t*...
> ...this can cause (without s at the end)...
> ...when the above situation *happens* (missing word)...
>
> - Sedat -
>
>> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 84f3144..8944651 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -522,10 +522,21 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>>         return 0;
>>  }
>>
>> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
>> +{
>> +       struct ovl_fs *ufs = sb->s_fs_info;
>> +
>> +       if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
>> +               *flags |= MS_RDONLY;
>> +
>> +       return 0;
>> +}
>> +
>>  static const struct super_operations ovl_super_operations = {
>>         .put_super      = ovl_put_super,
>>         .statfs         = ovl_statfs,
>>         .show_options   = ovl_show_options,
>> +       .remount_fs     = ovl_remount,
>>  };
>>
>>  enum {
>> --
>> 2.1.3
>>
Thank you for your correction!

I will fix it.

Thanks.
