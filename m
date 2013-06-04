Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab3FDPKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:10:00 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64742 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab3FDPJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:09:58 -0400
Message-ID: <51AE033D.8090302@gmail.com>
Date: Tue, 04 Jun 2013 23:09:49 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/8] zram: avoid access beyond the zram device
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com> <1370274140-26420-7-git-send-email-jiang.liu@huawei.com> <51ADE87F.9080303@redhat.com>
In-Reply-To: <51ADE87F.9080303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04 Jun 2013 09:15:43 PM CST, Jerome Marchand wrote:
> On 06/03/2013 05:42 PM, Jiang Liu wrote:
>> Function valid_io_request() should verify the entire request doesn't
>> exceed the zram device, otherwise it will cause invalid memory access.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  drivers/staging/zram/zram_drv.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 66cf28a..64b51b9 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -428,6 +428,10 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
>>  		return 0;
>>  	}
>>
>> +	if (unlikely((bio->bi_sector << SECTOR_SHIFT) + bio->bi_size >=
>> +		     zram->disksize))
>> +		return 0;
>> +
>
> This test make the first line of previous test redundant. Why not just
> update it like the following:
>
> -		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
> +		((bio->bi_sector << SECTOR_SHIFT) + bio->bi_size >=
> +			zram->disksize)) ||
>
>
> Jerome
Hi Jerome,
         I think the test "bio->bi_sector >= (zram->disksize >> 
SECTOR_SHIFT)" is still
needed to protect "(bio->bi_sector << SECTOR_SHIFT) + bio->bi_size" 
from wrapping
around.
Regards!
Gerry

>
>>  	/* I/O request is valid */
>>  	return 1;
>>  }
>>
>


