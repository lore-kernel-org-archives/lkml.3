Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3KHGU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:20:29 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:33370 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3KHGU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:20:27 -0500
MIME-Version: 1.0
In-Reply-To: <87zjpfv5w3.fsf@devron.myhome.or.jp>
References: <20131107074108.GB21844@elgon.mountain>
	<87zjpfv5w3.fsf@devron.myhome.or.jp>
Date: Fri, 8 Nov 2013 15:20:26 +0900
Message-ID: <CAKYAXd9M1W+2raJzkE+ZfTzL6Z=dnOiQ3UeL6c3fFAnTZnw3vg@mail.gmail.com>
Subject: Re: [patch] fat: double unlock on error path
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/8, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
>> There is a stray unlock here which was not intended.  I have removed it.
>>
>> Fixes: 3f9f3dfb5755 ('fat: add fat_fallocate operation')
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/fs/fat/file.c b/fs/fat/file.c
>> index 03f716f..befedee 100644
>> --- a/fs/fat/file.c
>> +++ b/fs/fat/file.c
>> @@ -257,10 +257,8 @@ static long fat_fallocate(struct file *file, int
>> mode,
>>  		goto error;
>>
>>  	err = inode_newsize_ok(inode, (len + offset));
>> -	if (err) {
>> -		mutex_unlock(&inode->i_mutex);
>> +	if (err)
>>  		goto error;
>> -	}
>>
>>  	if (mode & FALLOC_FL_KEEP_SIZE) {
>>  		/* First compute the number of clusters to be allocated */
>
> Right. Namjae, please include this fix to patchset at next time.
Okay, I will include it in the next patch-set.
Thank you!

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
