Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3AaBKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:10:49 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52380 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3AaBKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <1359594232.22847.56.camel@kjgkr>
References: <1359553622-7449-1-git-send-email-linkinjeon@gmail.com>
	<1359594232.22847.56.camel@kjgkr>
Date: Thu, 31 Jan 2013 10:10:42 +0900
Message-ID: <CAKYAXd_pmnJhF-C9fcwBphnut5YQXhOepKSfws=H7pvos1UHdg@mail.gmail.com>
Subject: Re: [PATCH 1/3] f2fs: avoid redundant call to has_not_enough_free_secs
 in f2fs_gc
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/31, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-01-30 (수), 22:47 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> After doing a write_checkpoint from garbage collection path if there is
>> still
>> need to do more garbage collection, gc_more label is used to jump and
>> start
>> the process again. And in that process, first step before getting victim
>> is to
>> check if there are not enough free sections, which is already done before
>> doing a jump to gc_more. We can avoid the redundant call to check free
>> sections, by checking the gc_type flag which will remain FG_GC(value 1)
>> under
>> this condition.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/gc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
>> index 9b5d0aa..0dfdaa5 100644
>> --- a/fs/f2fs/gc.c
>> +++ b/fs/f2fs/gc.c
>> @@ -672,7 +672,7 @@ gc_more:
>>  	if (!(sbi->sb->s_flags & MS_ACTIVE))
>>  		goto stop;
>>
>> -	if (has_not_enough_free_secs(sbi))
>> +	if (!gc_type && has_not_enough_free_secs(sbi))
>
> I applied this patch with the following change:
> 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi))
>
> Thank you. :)

Right!, Thanks Jaegeuk :)
>
>>  		gc_type = FG_GC;
>>
>>  	if (!__get_victim(sbi, &segno, gc_type, NO_CHECK_TYPE))
>
> --
> Jaegeuk Kim
> Samsung
>
