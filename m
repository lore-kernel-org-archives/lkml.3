Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbAAPav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:30:51 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45284 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbAAPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:30:47 -0500
Message-ID: <54A56822.8010308@gmail.com>
Date: Fri, 02 Jan 2015 00:30:42 +0900
From: Seunghun Lee <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com, Richard Weinberger <richard.weinberger@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
References: <1420088862-3549-1-git-send-email-waydi1@gmail.com>	<CAFLxGvxWoC_mekWjLQhrk9dExNUHKJ1vB+vT6HMV=xJ=DYm+Kg@mail.gmail.com> <CA+icZUVfdo=BN0TC6sFmOj3SqfLjsJHN-1YAUh8JS=TVF9XPgg@mail.gmail.com>
In-Reply-To: <CA+icZUVfdo=BN0TC6sFmOj3SqfLjsJHN-1YAUh8JS=TVF9XPgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/02/2015 12:24 AM, Sedat Dilek wrote:
> On Thu, Jan 1, 2015 at 4:13 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Thu, Jan 1, 2015 at 6:07 AM, Seunghun Lee <waydi1@gmail.com> wrote:
>>> Overlayfs should be mounted read-only when upper fs is r/o or nonexistend.
>>> But now it can be remounted read-write and this can causes kernel panic.
>>> So we should prevent read-write remount when the above situation.
>>>
>>> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
>> This patch makes zero sense, did you use the wrong diff?
>>
> Hmm, was also my 1st thoughts when I saw squashfs_remount() in overlayfs code.
>
> - Sedat -
>
>>> ---
>>>  fs/overlayfs/super.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index 84f3144..1faa5e5 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
>>> @@ -522,6 +522,14 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>>>         return 0;
>>>  }
>>>
>>> +static int squashfs_remount(struct super_block *sb, int *flags, char *data)
>>> +{
>>> +       if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
>>> +               *flags |= MS_RDONLY;
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>  static const struct super_operations ovl_super_operations = {
>>>         .put_super      = ovl_put_super,
>>>         .statfs         = ovl_statfs,
>>> --
>>> 2.1.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>> --
>> Thanks,
>> //richard
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Sorry, I sent wrong patch.

I will resend it.

Thanks.
