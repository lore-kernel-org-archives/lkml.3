Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3AUEPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:15:20 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64654 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:15:18 -0500
MIME-Version: 1.0
In-Reply-To: <87vcasxgre.fsf@devron.myhome.or.jp>
References: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com>
	<87vcasxgre.fsf@devron.myhome.or.jp>
Date: Mon, 21 Jan 2013 13:15:17 +0900
Message-ID: <CAKYAXd_DH+O4PKUsfQKVVXoi84Sm2f64A3+aESOgQb9JvX_e+w@mail.gmail.com>
Subject: Re: [PATCH] fat: eliminate iterations in fat_search_long in case of EOD
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/20, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> When searching a directory for names, we can stop checking for further
>> entries if we detect End of Directory, i.e. if (de->name[0] == 0x00).The
>> current code traverses the cluster chain of a directory until a hit is
>> found or till the last cluster for that directory, ignoring the EOD mark.
>> Fix this.
>
> f_pos still works fine after this change?
Hi OGAWA.
I can not find f_pos usage in fat_search_long function.
Maybe, Have you seen other function such as __fat_readdir ?
Let me know your opinion.

Thanks.
>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
>> ---
>>  fs/fat/dir.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
>> index 58bf744..cde0e69 100644
>> --- a/fs/fat/dir.c
>> +++ b/fs/fat/dir.c
>> @@ -484,10 +484,10 @@ parse_record:
>>  		nr_slots = 0;
>>  		if (de->name[0] == DELETED_FLAG)
>>  			continue;
>> +		if (!de->name[0])
>> +			goto end_of_dir;
>>  		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
>>  			continue;
>> -		if (de->attr != ATTR_EXT && IS_FREE(de->name))
>> -			continue;
>>  		if (de->attr == ATTR_EXT) {
>>  			int status = fat_parse_long(inode, &cpos, &bh, &de,
>>  						    &unicode, &nr_slots);
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
