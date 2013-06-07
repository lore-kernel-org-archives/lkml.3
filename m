Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3FGJn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:43:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60710 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3FGJn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:43:57 -0400
Message-ID: <51B1AB4F.1090206@gmail.com>
Date: Fri, 07 Jun 2013 17:43:43 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 05/10] zram: avoid access beyond the zram device
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com> <1370534851-26056-6-git-send-email-jiang.liu@huawei.com> <20130607080945.GD22516@blaptop> <51B1AA8A.4010005@redhat.com>
In-Reply-To: <51B1AA8A.4010005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 05:40 PM, Jerome Marchand wrote:
> On 06/07/2013 10:09 AM, Minchan Kim wrote:
>> On Fri, Jun 07, 2013 at 12:07:26AM +0800, Jiang Liu wrote:
>>> Function valid_io_request() should verify the entire request are within
...
>>>  
>>> +	start = bio->bi_sector;
>>> +	end = start + (bio->bi_size >> SECTOR_SHIFT);
>>> +	bound = zram->disksize >> SECTOR_SHIFT;
>>> +	/* out of range range */
>>> +	if (unlikely(start >= bound || end >= bound || start > end))
>>
>>         if (end >= bound || start > end) isn't enough?
> 
> I shall think so.
> 
> Jerome
Me too! But I realized this just after sending out the patchset
last night.

> 
>>
>>>  		return 0;
>>> -	}
>>>  
>>>  	/* I/O request is valid */
>>>  	return 1;
>>> -- 
>>> 1.8.1.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

