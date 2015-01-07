Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbAGKsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:48:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59059 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbAGKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:48:05 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ba-54ad0ee2342f
Message-id: <54AD0EDF.6080709@samsung.com>
Date: Wed, 07 Jan 2015 11:47:59 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Nishanth Menon <nm@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>,
        khilman@linaro.org
Subject: Re: [PATCH v11 2/9] ARM: l2c: use l2c_write_sec() for restoring
 latency and filter regs
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-3-git-send-email-m.szyprowski@samsung.com>
 <20150105172028.GA19579@kahuna>
In-reply-to: <20150105172028.GA19579@kahuna>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xq7qP+NaGGFxYpmvxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XS6xeZLN78OMtkcer6ZzaLVbv+MFrsv+LlIOSxZt4aRo+W5h42j9+/JjF6fPs6icXj
	cl8vk8ei71keO2fdZfe4c20Pm8fmJfUeV040sXr0bVnF6HH8xnYmj8+b5AJ4o7hsUlJzMstS
	i/TtErgyDq34zlgwTb5i49z37A2MvyS6GDk5JARMJHbd3coEYYtJXLi3nq2LkYtDSGApo8Tj
	C88YIZxPjBInrv5iB6niFdCSOHEfwmYRUJVYs+oKM4jNJmAo0fW2iw3EFhWIkVi8cDUzRL2g
	xI/J91i6GDk4RATkJGZt8gQJMwssYJFY+tQSxBYWSJLY87ybGWLXSkaJhVd3gPVyCuhInP29
	iAWiwUziy8vDrBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L
	10vOz93ECInOrzsYlx6zOsQowMGoxMOrMHlNiBBrYllxZe4hRgkOZiUR3je/gEK8KYmVValF
	+fFFpTmpxYcYmTg4pRoY955mvBm68tSHlAXxG59vvMvQFGxx1qJ0yuE1sQdK5YziXL9d6yno
	1t8nsfcrszvb5ad1PyfI2tS7yRfd4Cq9nrLuYa5TheXiwBfn1F1aJZhy1GwCLnB3b/7n6vGH
	Q6c/cdLa1JVxJiZsC7eqFt26zyIyz3Z5icG7NwHTXb99zojdJPhQjHmbEktxRqKhFnNRcSIA
	/Rc7HKwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2015-01-05 18:20, Nishanth Menon wrote:
> On 13:19-20150105, Marek Szyprowski wrote:
>> All four register for latency and filter settings cannot be written in
>> non-secure mode and they should go through l2c_write_sec(). More on this
>> can be found in CoreLink Level 2 Cache Controller L2C-310 Technical
>> Reference Manual, 3.2. Register summary, table 3.1. This have been checked
>> the TRM for r3p3, but it should be uniform for all revisions.
>>
>> Reported-by: Nishanth Menon <nm@ti.com>
>> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   arch/arm/mm/cache-l2x0.c | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>> index 5e65ca8dea62..0aeeaa95c42d 100644
>> --- a/arch/arm/mm/cache-l2x0.c
>> +++ b/arch/arm/mm/cache-l2x0.c
>> @@ -623,14 +623,14 @@ static void l2c310_resume(void)
>>   		unsigned revision;
>>   
>>   		/* restore pl310 setup */
>> -		writel_relaxed(l2x0_saved_regs.tag_latency,
>> -			       base + L310_TAG_LATENCY_CTRL);
>> -		writel_relaxed(l2x0_saved_regs.data_latency,
>> -			       base + L310_DATA_LATENCY_CTRL);
>> -		writel_relaxed(l2x0_saved_regs.filter_end,
>> -			       base + L310_ADDR_FILTER_END);
>> -		writel_relaxed(l2x0_saved_regs.filter_start,
>> -			       base + L310_ADDR_FILTER_START);
>> +		l2c_write_sec(l2x0_saved_regs.tag_latency, base,
>> +			      L310_TAG_LATENCY_CTRL);
>> +		l2c_write_sec(l2x0_saved_regs.data_latency, base,
>> +			      L310_DATA_LATENCY_CTRL);
>> +		l2c_write_sec(l2x0_saved_regs.filter_end, base,
>> +			      L310_ADDR_FILTER_END);
>> +		l2c_write_sec(l2x0_saved_regs.filter_start, base,
>> +			      L310_ADDR_FILTER_START);
>>   
>>   		revision = readl_relaxed(base + L2X0_CACHE_ID) &
>>   				L2X0_CACHE_ID_RTL_MASK;
> Do you need the following as well at this point in the patch series?
> Agreed that the writes will disappear later in the series.

Right. Thanks for pointing this. I will send an updated version, which
will also fix the checkpatch --strict issues.

> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 0aeeaa9..7afab37 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -1135,28 +1135,28 @@ static void __init l2c310_of_parse(const struct device_node *np,
>   
>   	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
>   	if (tag[0] && tag[1] && tag[2])
> -		writel_relaxed(
> +		l2c_write_sec(
>   			L310_LATENCY_CTRL_RD(tag[0] - 1) |
>   			L310_LATENCY_CTRL_WR(tag[1] - 1) |
>   			L310_LATENCY_CTRL_SETUP(tag[2] - 1),
> -			l2x0_base + L310_TAG_LATENCY_CTRL);
> +			l2x0_base, L310_TAG_LATENCY_CTRL);
>   
>   	of_property_read_u32_array(np, "arm,data-latency",
>   				   data, ARRAY_SIZE(data));
>   	if (data[0] && data[1] && data[2])
> -		writel_relaxed(
> +		l2c_write_sec(
>   			L310_LATENCY_CTRL_RD(data[0] - 1) |
>   			L310_LATENCY_CTRL_WR(data[1] - 1) |
>   			L310_LATENCY_CTRL_SETUP(data[2] - 1),
> -			l2x0_base + L310_DATA_LATENCY_CTRL);
> +			l2x0_base,  L310_DATA_LATENCY_CTRL);
>   
>   	of_property_read_u32_array(np, "arm,filter-ranges",
>   				   filter, ARRAY_SIZE(filter));
>   	if (filter[1]) {
> -		writel_relaxed(ALIGN(filter[0] + filter[1], SZ_1M),
> -			       l2x0_base + L310_ADDR_FILTER_END);
> -		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
> -			       l2x0_base + L310_ADDR_FILTER_START);
> +		l2c_write_sec(ALIGN(filter[0] + filter[1], SZ_1M),
> +			       l2x0_base, L310_ADDR_FILTER_END);
> +		l2c_write_sec((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
> +			       l2x0_base, L310_ADDR_FILTER_START);
>   	}
>   
>   	ret = l2x0_cache_size_of_parse(np, aux_val, aux_mask, &assoc, SZ_512K);
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

