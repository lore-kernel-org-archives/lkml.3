Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaF1Vih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:38:37 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:54490 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaF1Vig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:38:36 -0400
Message-ID: <53AF35D2.4090904@elopez.com.ar>
Date: Sat, 28 Jun 2014 18:38:26 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] clk: sunxi: fix devm_ioremap_resource error detection
 code
References: <20140628172355.GA3387@himangi-Dell> <53AF024B.3010100@free-electrons.com>
In-Reply-To: <53AF024B.3010100@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 28/06/14 14:58, Boris BREZILLON escribió:
> Hello,
>
> On 28/06/2014 19:23, Himangi Saraogi wrote:
>> devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows:
>>
>> // <smpl>
>> @@
>> expression e,e1;
>> statement S;
>> @@
>>
>> *e = devm_ioremap_resource(...);
>> if (!e1) S
>>
>> // </smpl>
>> Signed-off-by: Himangi Saraogi<himangi774@gmail.com>
>> Acked-by: Julia Lawall<julia.lawall@lip6.fr>
>> ---
>>   drivers/clk/sunxi/clk-sun6i-apb0-gates.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
>> index 44cd27c..670f90d 100644
>> --- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
>> +++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
>> @@ -29,7 +29,7 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
>>
>>   	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>   	reg = devm_ioremap_resource(&pdev->dev, r);
>> -	if (!reg)
>> +	if (IS_ERR(reg))
>>   		return PTR_ERR(reg);
>>
>>   	clk_parent = of_clk_get_parent_name(np, 0);
>
> Oops, one more mistake in testing devm_ioremap_resource return code (I
> always mix devm_ioremap_resource and devm_request_and_ioremap behaviours).
>
> Sorry for the inconvenience, and of course, you have my:
>
> Acked-by Boris BREZILLON <boris.brezillon@free-electrons.com>

Mike, do you want to take this directly for the -rc cycle, or should I 
queue it for 3.17? Please let me know.

Cheers,

Emilio
