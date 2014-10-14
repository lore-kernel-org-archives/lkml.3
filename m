Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaJNPWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:22:41 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:52024 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaJNPWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <1413052541.22149.10.camel@joe-AO725>
References: <1413052311-2646-1-git-send-email-rahulbedarkar89@gmail.com> <1413052541.22149.10.camel@joe-AO725>
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Tue, 14 Oct 2014 20:52:19 +0530
Message-ID: <CA+NV+VmvKVsDwt4hUq+ZgsZ5aQ5p3knJLae_GO0XD9jppn=wKw@mail.gmail.com>
Subject: Re: [PATCH] char: misc: use pr_err instead of printk
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 12:05 AM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-10-12 at 00:01 +0530, Rahul Bedarkar wrote:
> []
>> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> []
>> @@ -280,12 +280,12 @@ static int __init misc_init(void)
>>
>>       err = -EIO;
>>       if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
>> -             goto fail_printk;
>> +             goto fail_pr_err;
>>       misc_class->devnode = misc_devnode;
>>       return 0;
>>
>> -fail_printk:
>> -     printk("unable to get major %d for misc devices\n", MISC_MAJOR);
>> +fail_pr_err:
>> +     pr_err("unable to get major %d for misc devices\n", MISC_MAJOR);
>>       class_destroy(misc_class);
>>  fail_remove:
>>       remove_proc_entry("misc", NULL);
>
> The printk is not relevant.
> Maybe the label should be "fail_destroy:"

Ok. I will split this in two separate patches one renames label first and
other use pr_err instead of printk. I will resend this patch

Thanks,
Rahul

>
