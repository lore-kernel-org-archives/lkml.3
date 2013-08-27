Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3H0M72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:59:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52291 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3H0M70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:59:26 -0400
Message-ID: <521CA2A9.5060200@ti.com>
Date: Tue, 27 Aug 2013 18:29:21 +0530
From: ManishBadarkhe <manishv.b@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: pinctrl-single: Convert to devm_ioremap_resource()
References: <1377587134-8967-1-git-send-email-manishv.b@ti.com> <521C9946.70009@cogentembedded.com>
In-Reply-To: <521C9946.70009@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 27 August 2013 05:49 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 27-08-2013 11:05, Vishwanathrao Badarkhe, Manish wrote:
>
>> From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
>
>> Convert devm_request_mem_region() and devm_ioremap() to
>> devm_ioremap_resource() which provides more consistent
>> error handling to manage resource.
>
>> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
>> ---
>> :100644 100644 7323cca... b0fef18... M drivers/pinctrl/pinctrl-single.c
>>   drivers/pinctrl/pinctrl-single.c |   21 +++------------------
>>   1 file changed, 3 insertions(+), 18 deletions(-)
>
>> diff --git a/drivers/pinctrl/pinctrl-single.c 
>> b/drivers/pinctrl/pinctrl-single.c
>> index 7323cca..b0fef18 100644
>> --- a/drivers/pinctrl/pinctrl-single.c
>> +++ b/drivers/pinctrl/pinctrl-single.c
>> @@ -1556,24 +1556,9 @@ static int pcs_probe(struct platform_device 
>> *pdev)
>>                             "pinctrl-single,bit-per-mux");
>>
>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -    if (!res) {
>> -        dev_err(pcs->dev, "could not get resource\n");
>> -        return -ENODEV;
>> -    }
>> -
>> -    pcs->res = devm_request_mem_region(pcs->dev, res->start,
>> -            resource_size(res), DRIVER_NAME);
>> -    if (!pcs->res) {
>
>    Is pcs->res used anywhere else?

My bad, I have not seen this variable is used in another functions too.
>
>> -        dev_err(pcs->dev, "could not get mem_region\n");
>> -        return -EBUSY;
>> -    }
>> -
>> -    pcs->size = resource_size(pcs->res);
>
>    Is pcs->size used anywhere else?
My bad, I have not seen this variable is used in another functions too.
>
>> -    pcs->base = devm_ioremap(pcs->dev, pcs->res->start, pcs->size);
>> -    if (!pcs->base) {
>> -        dev_err(pcs->dev, "could not ioremap\n");
>> -        return -ENODEV;
>> -    }
>> +    pcs->base = devm_ioremap_resource(pcs->dev, res);
>> +    if (IS_ERR(pcs->base))
>> +        return PTR_ERR(pcs->base);
>
I will go through code again and update it accordingly.
>
Regards
Manish Badarkhe
