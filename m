Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJPBzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:55:13 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40518 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaJPBzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <1413415606.7484.19.camel@perches.com>
References: <1413414942-5338-1-git-send-email-bino@riseup.net>
	<1413415606.7484.19.camel@perches.com>
Date: Wed, 15 Oct 2014 22:55:09 -0300
Message-ID: <CA+bYFQZrdVaSUpzfPnhaVL_JorZt6fLO+ObqxgQKd3k8OWfi8Q@mail.gmail.com>
Subject: Re: [PATCH] Change for codestyle and good read
From: Albino Biasutti Neto <bino@riseup.net>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-15 20:26 GMT-03:00 Joe Perches <joe@perches.com>:
> On Wed, 2014-10-15 at 20:15 -0300, Albino Biasutti Neto wrote:
>> ---
>
> Are you not mentioning the logic changes because you
> didn't notice them?
>> diff --git a/fs/open.c b/fs/open.c
> []
>> @@ -71,10 +71,8 @@ long vfs_truncate(struct path *path, loff_t length)
>>       inode = path->dentry->d_inode;
>>
>>       /* For directories it's -EISDIR, for other non-regulars - -EINVAL */
>> -     if (S_ISDIR(inode->i_mode))
>> +     if ((S_ISDIR(inode->i_mode)) && (!S_ISRG(inode->i_mode)))
>>               return -EISDIR;
>> -     if (!S_ISREG(inode->i_mode))
>> -             return -EINVAL;
>
> Don't think so...
>
> Did you read the comment?

No.

>> @@ -137,14 +135,13 @@ retry:
>>       return error;
>>  }
>>
>> -SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
>> -{
>> +SYSCALL_DEFINE2(truncate, const char __user *, path, long, length) {
>>       return do_sys_truncate(path, length);
>>  }
>
> Poorer, non-kernel style
>
> []
>
> diff --git a/kernel/exit.c b/kernel/exit.c
>> index 32c58f7..f429fdd 100644
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -78,8 +78,8 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>>  }
>>
>>  /*
>> - * This function expects the tasklist_lock write-locked.
>> - */
>> + * This function expects the tasklist_lock write-locked.
>> +*/
>>  static void __exit_signal(struct task_struct *tsk)
>>  {
>>       struct signal_struct *sig = tsk->signal;
>
> Adding trailing whitespace and misaligning too.
>

I'm writing my first kernel patch, sorry. I will be better in the next.

                          Albino
                          binoanb.eti.br
