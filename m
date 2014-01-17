Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaAQS1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:27:44 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53212 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaAQS1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:27:43 -0500
Message-ID: <52D977D4.3060708@linux.vnet.ibm.com>
Date: Sat, 18 Jan 2014 00:05:00 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH]  fs null_blk: Null pointer deference problem in alloc_page_buffers
References: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <x49sismzevl.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sismzevl.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011718-9574-0000-0000-00000B8A1064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 11:09 PM, Jeff Moyer wrote:
> Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> writes:
>
>> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
>> index a2e69d2..6b0e049 100644
>> --- a/drivers/block/null_blk.c
>> +++ b/drivers/block/null_blk.c
>> @@ -535,6 +535,11 @@ static int null_add_dev(void)
>>   	if (!nullb)
>>   		return -ENOMEM;
>>
>> +	if (bs > PAGE_SIZE) {
>> +		WARN(1, "Invalid block size. Setting it to 4096\n");
>> +		bs = 4096;
>> +	}
>> +
>
> Why are you hard-coding 4k instead of just using PAGE_SIZE?
>

Thanks Jeff. Yes,that makes sense. will change.
(got same suggestion from reporter here too)

