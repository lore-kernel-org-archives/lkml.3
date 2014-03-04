Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaCDKvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:51:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33168 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaCDKvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:51:13 -0500
Message-ID: <5315AFFA.40101@ti.com>
Date: Tue, 4 Mar 2014 12:50:34 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/5] drivers: bus: omap_l3: Convert to use devm_request_and_ioremap()
References: <1393923710-10377-1-git-send-email-peter.ujfalusi@ti.com> <1393923710-10377-3-git-send-email-peter.ujfalusi@ti.com> <1393924359.866301359@f148.i.mail.ru>
In-Reply-To: <1393924359.866301359@f148.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 11:12 AM, Alexander Shiyan wrote:
> Вторник,  4 марта 2014, 11:01 +02:00 от Peter Ujfalusi <peter.ujfalusi@ti.com>:
>> We can then remove the iounmap() calls from probe and remove.
>> Since the driver requests the resources via index we can do the mem resource
>> request within a for loop.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti>
>> ---
> 
>> +	/* Get mem resources */
>> +	for (i = 0; i < 3; i++) {
>> +		struct resource	*res = platform_get_resource(pdev,
>> +							     IORESOURCE_MEM, i);
>> +		if (!res) {
>> +			dev_err(&pdev->dev, "couldn't find resource %d\n", i);
>> +			return -ENODEV;
>> +		}
> 
> No need to check "res". devm_request_and_ioremap() do all for us.
> 
>> -	l3->l3_base[2] = ioremap(res->start, resource_size(res));
>> -	if (!l3->l3_base[2]) {
>> -		dev_err(&pdev->dev, "ioremap failed\n");
>> -		ret = -ENOMEM;
>> -		goto err2;
>> +		l3->l3_base[i] = devm_request_and_ioremap(&pdev->dev, res);
>> +		if (!l3->l3_base[i]) {
> 
> if (IS_ERR(l3->l3_base[i]))
> 
>> +			dev_err(&pdev->dev, "ioremap %d failed\n", i);
> 
> Unnecessary.

I'm going to keep this since it tells which resource of the three has failed.

> 
>> +			return -ENOMEM;
> 
> return PTR_ERR(l3->l3_base[i]);
> 
> ---
> 


-- 
Péter
