Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3EWWhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 18:37:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51638 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab3EWWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 18:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <519E287E.4010307@gmail.com>
References: <1369317502-14380-1-git-send-email-linkinjeon@gmail.com>
	<519E287E.4010307@gmail.com>
Date: Fri, 24 May 2013 07:37:49 +0900
Message-ID: <CAKYAXd_Yfu7OE9EOhCbfTHOz-KpD4dS+U_90LEnTuf34dCx29w@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH 3/4] f2fs: return proper error from start_gc_thread
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jason Hrycay <jhrycay@gmail.com>
Cc: jaegeuk.kim@samsung.com, Amit Sahrawat <a.sahrawat@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        jason.hrycay@motorola.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/23, Jason Hrycay <jhrycay@gmail.com>:
> On 5/23/2013 8:58 AM, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> when there is an error from kthread_run, then return proper error
>> rather than returning -ENOMEM.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/gc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
>> index 25b083c..03d5ba1 100644
>> --- a/fs/f2fs/gc.c
>> +++ b/fs/f2fs/gc.c
>> @@ -105,7 +105,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>>  	if (IS_ERR(gc_th->f2fs_gc_task)) {
>>  		kfree(gc_th);
>
> gc_th is free'd here, save off PTR_ERR result to avoid use-after-free?
Yes, I will change this patch.
Thanks for review :)
>
>>  		sbi->gc_thread = NULL;
>> -		return -ENOMEM;
>> +		return PTR_ERR(gc_th->f2fs_gc_task);
>>  	}
>>  	return 0;
>>  }
>>
>
> --
> Jason Hrycay
>
