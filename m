Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3KQWel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 17:34:41 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38529 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KQWei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 17:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <1384724403.2727.22.camel@joe-AO722>
References: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
	<1384724403.2727.22.camel@joe-AO722>
Date: Sun, 17 Nov 2013 20:34:37 -0200
Message-ID: <CAK4VdL2nKEE+xb=HtMGNsMGNR_ivUn_WnLi7X-rrXT0fpGbSTw@mail.gmail.com>
Subject: Re: [PATCH] jffs2: fix sparse errors: directive in argument list
From: Erico Nunes <nunes.erico@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-sparse@vger.kernel.org, dwmw2 <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.

I'll resubmit shortly.

Do you mean it as an error in the sparse tool?
I don't think so, I took a look and it seems to be designed to output
an error for that case.


On Sun, Nov 17, 2013 at 7:40 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2013-11-17 at 18:18 -0200, Erico Nunes wrote:
>> This patch fixes the following errors reported when running sparse:
>> fs/jffs2/super.c:378:1: error: directive in argument list
>> fs/jffs2/super.c:380:1: error: directive in argument list
>> fs/jffs2/super.c:381:1: error: directive in argument list
>> fs/jffs2/super.c:383:1: error: directive in argument list
>
> Seems like a sparse error more than anything else.
> (adding sparse mailing list)
>
> Also you need to add a "Signed-off-by:" line
> with your email address.
>
> see: Documentation/SubmittingPatches
>
>> ---
>>  fs/jffs2/super.c | 17 +++++++++--------
>>  1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
>> index 0defb1c..ec9e16f 100644
>> --- a/fs/jffs2/super.c
>> +++ b/fs/jffs2/super.c
>> @@ -361,6 +361,14 @@ MODULE_ALIAS_FS("jffs2");
>>  static int __init init_jffs2_fs(void)
>>  {
>>       int ret;
>> +     const char desc[] = "version 2.2."
>> +#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
>> +             " (NAND)"
>> +#endif
>> +#ifdef CONFIG_JFFS2_SUMMARY
>> +             " (SUMMARY) "
>> +#endif
>> +             " © 2001-2006 Red Hat, Inc.";
>>
>>       /* Paranoia checks for on-medium structures. If we ask GCC
>>          to pack them with __attribute__((packed)) then it _also_
>> @@ -374,14 +382,7 @@ static int __init init_jffs2_fs(void)
>>       BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
>>       BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);
>>
>> -     pr_info("version 2.2."
>> -#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
>> -            " (NAND)"
>> -#endif
>> -#ifdef CONFIG_JFFS2_SUMMARY
>> -            " (SUMMARY) "
>> -#endif
>> -            " © 2001-2006 Red Hat, Inc.\n");
>> +     pr_info("%s\n", desc);
>>
>>       jffs2_inode_cachep = kmem_cache_create("jffs2_i",
>>                                            sizeof(struct jffs2_inode_info),
>
>
>
