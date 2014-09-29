Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaI2Eqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:46:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaI2Eqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:46:38 -0400
Message-ID: <5428E42A.6090206@codeaurora.org>
Date: Mon, 29 Sep 2014 07:46:34 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <20140928181354.GB2782@hudson.localdomain>
In-Reply-To: <20140928181354.GB2782@hudson.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremiah,

On 9/28/2014 9:13 PM, Jeremiah Mahler wrote:
> Tanya,
>
> On Sun, Sep 28, 2014 at 09:37:00AM +0300, Tanya Brokhman wrote:
>> The need for performing read disturb is determined according to new
>> statistics collected per eraseblock:
>> - read counter: incremented at each read operation
>>                  reset at each erase
>> - last erase time stamp: updated at each erase
>>
>> This patch adds the infrastructure for the above statistics
>>
>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>> ---
> ...
>> @@ -385,6 +402,38 @@ static ssize_t dev_attribute_show(struct device *dev,
>>   	return ret;
>>   }
>>
>> +static ssize_t dev_attribute_store(struct device *dev,
>> +			   struct device_attribute *attr,
>> +			   const char *buf, size_t count)
>> +{
>> +	int value;
>> +	struct ubi_device *ubi;
>> +
>> +	ubi = container_of(dev, struct ubi_device, dev);
>> +	ubi = ubi_get_device(ubi->ubi_num);
>> +	if (!ubi)
>> +		return -ENODEV;
>> +
>> +	if (kstrtos32(buf, 10, &value))
>> +		return -EINVAL;
>> +	/* Consider triggering full scan if threshods change */
>> +	else if (attr == &dev_dt_threshold) {
>> +		if (value < UBI_MAX_DT_THRESHOLD)
>> +			ubi->dt_threshold = value;
>> +		else
>> +			pr_err("Max supported threshold value is %d",
>> +				   UBI_MAX_DT_THRESHOLD);
>> +	} else if (attr == &dev_rd_threshold) {
>> +		if (value < UBI_MAX_READCOUNTER)
>> +			ubi->rd_threshold = value;
>> +		else
>> +			pr_err("Max supported threshold value is %d",
>> +				   UBI_MAX_READCOUNTER);
>> +	}
>> +
>> +	return count;
>> +}
>> +
> ...
>
> One small style nit.  As per Documentation/CodingStyle [line 169] if
> one branch in a conditional uses braces then all branches should use
> braces.
>

I'm sorry but I understand it differently. From CodingStyle:
"This does not apply if only one branch of a conditional statement is a 
single
statement; in the latter case use braces in both branches:

if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}"
According to my understanding this doesn't mean {} should be added in 
case of an if statement inside an if statement. So the above code seems 
to be complaint with the coding style.
Please correct me if I'm misunderstanding something.

Thanks,
- Tanya Brokhman

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
