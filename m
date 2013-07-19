Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378Ab3GSPOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:14:18 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:45129 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3GSPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org> <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
From: Alexandru Juncu <alexj@rosedu.org>
Date: Fri, 19 Jul 2013 18:13:55 +0300
X-Google-Sender-Auth: dhfZaR1BSFzOBTiJy-M6VUINZZk
Message-ID: <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
To: Pekka Enberg <penberg@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        tao.peng@emc.com, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2013 18:08, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, Jul 19, 2013 at 5:45 PM, Alexandru Juncu <alexj@rosedu.org> wrote:
>> Found using coccinelle. It suggested kmalloc/strcpy should be replaced
>> with kstrdup, but the entire function can be replaced by kstrdup.
>>
>> Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
>> ---
>>  drivers/staging/lustre/lustre/libcfs/libcfs_string.c | 13 +------------
>>  1 file changed, 1 insertion(+), 12 deletions(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>> index 9edccc9..4dba304 100644
>> --- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>> +++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>> @@ -135,18 +135,7 @@ EXPORT_SYMBOL(cfs_str2mask);
>>  /* Duplicate a string in a platform-independent way */
>>  char *cfs_strdup(const char *str, u_int32_t flags)
>>  {
>> -       size_t lenz; /* length of str + zero byte */
>> -       char *dup_str;
>> -
>> -       lenz = strlen(str) + 1;
>> -
>> -       dup_str = kmalloc(lenz, flags);
>> -       if (dup_str == NULL)
>> -               return NULL;
>> -
>> -       memcpy(dup_str, str, lenz);
>> -
>> -       return dup_str;
>> +       return kstrdup(str, flags);
>>  }
>>  EXPORT_SYMBOL(cfs_strdup);
>
> It would be better if you replaced the calls to cfs_strdup() with
> kstrdup() and got rid of cfs_strdup() altogether.

I was thinking the same thing, but I hesitated because I didn't know
how used it was and I didn't want to break something.
