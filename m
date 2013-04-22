Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3DVDjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:39:12 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53418 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3DVDjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <1366598966.31792.1.camel@kjgkr>
References: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
	<1366598966.31792.1.camel@kjgkr>
Date: Mon, 22 Apr 2013 12:39:09 +0900
Message-ID: <CAKYAXd_VCEdN-qfu4-yZk847hYbBi=5dtGFKYGPYJDRQ0PAkKQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add REQ_META about metadata requests for submit bio
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/22, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-04-20 (토), 01:27 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Adding REQ_META for all the metadata requests can help in improving the
>> FS performance, if the underlying device supports TAGGING.
>> So, when considering the submit_bio path for all the f2fs requests. We
>> can
>> add REQ_META for all the META requests.
>> As a precursor to this change we considered the commit
>> 4265900e0be653f5b78baf2816857ef57cf1332f 'mmc: MMC-4.5 Data Tag Support'
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/segment.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>> index 1193a26..a2e5de7 100644
>> --- a/fs/f2fs/segment.c
>> +++ b/fs/f2fs/segment.c
>> @@ -689,6 +689,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>>  	if (type >= META_FLUSH)
>>  		rw = WRITE_FLUSH_FUA;
>>
>> +	if (type == META)
>
> Should be if (btype == META).
> Thanks,
Yes, Right :)
Thanks for fixing.
>
>> +		rw |= REQ_META;
>> +
>>  	if (sbi->bio[btype]) {
>>  		struct bio_private *p = sbi->bio[btype]->bi_private;
>>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,
>
> --
> Jaegeuk Kim
> Samsung
>
