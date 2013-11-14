Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3KNUEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:04:25 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56132 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3KNUER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:04:17 -0500
MIME-Version: 1.0
In-Reply-To: <20131114200234.GB7693@boyd>
References: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
	<20131114195238.GA7693@boyd>
	<CAGG-pURhr-YkQT5xLefK0=uN7vNx_EGJob=w54Z7VzcjYb=qiA@mail.gmail.com>
	<20131114200234.GB7693@boyd>
Date: Thu, 14 Nov 2013 18:04:16 -0200
Message-ID: <CAGG-pURF7B25XuutjFePwE5ONuG8YYQqbjAwf4K8ea-LKFvW9Q@mail.gmail.com>
Subject: Re: [PATCH] ecryptfs: Fix explicit null dereference
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: "open list:ECRYPT FILE SYSTEM" <ecryptfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/14 Tyler Hicks <tyhicks@canonical.com>:
> On 2013-11-14 17:58:40, Geyslan Gregório Bem wrote:
>> 2013/11/14 Tyler Hicks <tyhicks@canonical.com>:
>> > On 2013-11-14 15:42:14, Geyslan G. Bem wrote:
>> >> If the condition 'ecryptfs_file_to_private(file)' takes false branch
>> >> lower_file is dereferenced when NULL.
>> >>
>> >> Caught by Coverity: CIDs 1128834 and 1128833.
>> >>
>> >> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> >> ---
>> >
>> > Hello - Smatch picked up on this earlier in week and Dan analyzed the
>> > situation here:
>> >
>> >   http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/441
>> >
>> > I agree with his assessment and proposed the following patch:
>> >
>> >   http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/442
>> >
>> > It makes Smatch happy and it should also make Coverity happy.
>> >
>> > Tyler
>>
>> True. Disregard mine.
>>
>> Thanks Tyler.
>
> Thank you! Can I add your Reviewed-by: tag to that patch prior to
> pushing it to my next branch?
>
> Tyler
>

Sure, Tyler. You can! :)

Thanks again.

>>
>> >
>> >>  fs/ecryptfs/file.c | 12 ++++++++----
>> >>  1 file changed, 8 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
>> >> index 2229a74..1c0403a 100644
>> >> --- a/fs/ecryptfs/file.c
>> >> +++ b/fs/ecryptfs/file.c
>> >> @@ -316,10 +316,12 @@ ecryptfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>> >>       struct file *lower_file = NULL;
>> >>       long rc = -ENOTTY;
>> >>
>> >> -     if (ecryptfs_file_to_private(file))
>> >> -             lower_file = ecryptfs_file_to_lower(file);
>> >> +     if (!ecryptfs_file_to_private(file))
>> >> +             goto out;
>> >> +     lower_file = ecryptfs_file_to_lower(file);
>> >>       if (lower_file->f_op->unlocked_ioctl)
>> >>               rc = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
>> >> +out:
>> >>       return rc;
>> >>  }
>> >>
>> >> @@ -330,10 +332,12 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>> >>       struct file *lower_file = NULL;
>> >>       long rc = -ENOIOCTLCMD;
>> >>
>> >> -     if (ecryptfs_file_to_private(file))
>> >> -             lower_file = ecryptfs_file_to_lower(file);
>> >> +     if (!ecryptfs_file_to_private(file))
>> >> +             goto out;
>> >> +     lower_file = ecryptfs_file_to_lower(file);
>> >>       if (lower_file->f_op && lower_file->f_op->compat_ioctl)
>> >>               rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
>> >> +out:
>> >>       return rc;
>> >>  }
>> >>  #endif
>> >> --
>> >> 1.8.4.2
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Regards,
>>
>> Geyslan G. Bem
>> hackingbits.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Geyslan G. Bem
hackingbits.com
