Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaEZIiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:38:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15440 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaEZIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:38:19 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-db-5382fd784021
Message-id: <5382FD78.3060402@gmail.com>
Date: Mon, 26 May 2014 17:38:16 +0900
From: Jaehoon Chung <jh80.chung@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH 1/3] mmc: host: add slot argument to mmc_of_parse
References: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
 <1400840721-11050-2-git-send-email-jh80.chung@samsung.com>
 <20140526080916.GE12777@ldesroches-Latitude-E6320>
In-reply-to: <20140526080916.GE12777@ldesroches-Latitude-E6320>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd2Kv03BBpMPmFpMuLyd0WL+kXOs
	Fjd+tbFaXN41h83iyP9+RosZ5/cxWXy4f5HZov3vXjaL42vDHTg97lzbw+Zx49VCJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKuHhhCnPBHpmKs28+sjYw/hfrYuTkkBAwkWh8vI0JwhaT
	uHBvPVsXIxeHkMAiRomLt1pYQBJCAq8ZJSZvlgaxeQU0JPY8WMgMYrMIqEr8Pd7FDmKzCWhJ
	/Fp+nxHEFhUIk3i6+Q8bRL2gxI/J98DmiAjsZ5K4vDsHxBYWcJU4dWspE8SyHYwS3Td2AQ3l
	4OAUsJeYeyQMpIZZQEdif+s0NghbXmLzmrfMExj5ZyEZOwtJ2SwkZQsYmVcxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBAf1M6kdjCsbLA4xCnAwKvHwHvBuChZiTSwrrsw9xCjBwawkwtv8
	ASjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB8XhD9sLO
	C8valK8djdV3zp0k++HSzkv/ipkYc3I6K3ekbmWaELgk5MXFXJ/XWltT/q//cJVjQ8KTNdtd
	yiKKNi7/9uWq3vbI7csV2y52HPvuWzTP+cWDNyV1LLExn+uTnmkv+XfyfLvhc+fKrlgz60dV
	4WYbzC3z5j98Zx8UemebZdkh//fVOUosxRmJhlrMRcWJAMj4JK5mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/26/2014 05:09 PM, Ludovic Desroches wrote:
> On Fri, May 23, 2014 at 07:25:19PM +0900, Jaehoon Chung wrote:
>> From: Ludovic Desroches <ludovic.desroches@atmel.com>
>>
>> Some hosts manage several slots. In these case information such as the
>> bus width, chi detect and others are into the slot node. So we have to
> 
> /s/chi detect/chip detect
Will fix.

Tushar have suggested the rename mmc_of_parse_slot() instead of __mmc_of_parse().
I'm not sure which name is better. How about?

If never mind, i will change to mmc_of_parse_slot(), then send patch-v2.

Best Regards,
Jaehoon Chung
> 
>> parse child node. If not NULL, slot node will be used instead of the
>> device node.
>>
>> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> ---
>>  drivers/mmc/core/host.c  |   13 +++++++++----
>>  include/linux/mmc/host.h |   10 +++++++++-
>>  2 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
>> index 95cceae..0f677b3 100644
>> --- a/drivers/mmc/core/host.c
>> +++ b/drivers/mmc/core/host.c
>> @@ -298,15 +298,17 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
>>  #endif
>>  
>>  /**
>> - *	mmc_of_parse() - parse host's device-tree node
>> + *	__mmc_of_parse() - parse host's device-tree node
>>   *	@host: host whose node should be parsed.
>> + *	@slot : some device provide several slots so the node to parse
>> + *		is not the host one.
>>   *
>>   * To keep the rest of the MMC subsystem unaware of whether DT has been
>>   * used to to instantiate and configure this host instance or not, we
>>   * parse the properties and set respective generic mmc-host flags and
>>   * parameters.
>>   */
>> -int mmc_of_parse(struct mmc_host *host)
>> +int __mmc_of_parse(struct mmc_host *host, struct device_node *slot)
>>  {
>>  	struct device_node *np;
>>  	u32 bus_width;
>> @@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
>>  	if (!host->parent || !host->parent->of_node)
>>  		return 0;
>>  
>> -	np = host->parent->of_node;
>> +	if (slot)
>> +		np = slot;
>> +	else
>> +		np = host->parent->of_node;
>>  
>>  	/* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
>>  	if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
>> @@ -459,7 +464,7 @@ out:
>>  	return ret;
>>  }
>>  
>> -EXPORT_SYMBOL(mmc_of_parse);
>> +EXPORT_SYMBOL(__mmc_of_parse);
>>  
>>  /**
>>   *	mmc_alloc_host - initialise the per-host structure.
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index 7960424..c62af91 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -372,7 +372,15 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *);
>>  int mmc_add_host(struct mmc_host *);
>>  void mmc_remove_host(struct mmc_host *);
>>  void mmc_free_host(struct mmc_host *);
>> -int mmc_of_parse(struct mmc_host *host);
>> +int __mmc_of_parse(struct mmc_host *host, struct device_node *slot);
>> +/*
>> + * mmc_of_parse - parse host's device-tree node
>> + *	@host: host whose node should be parsed.
>> + */
>> +static inline int mmc_of_parse(struct mmc_host *host)
>> +{
>> +	return __mmc_of_parse(host, NULL);
>> +}
>>  
>>  static inline void *mmc_priv(struct mmc_host *host)
>>  {
>> -- 
>> 1.7.9.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

