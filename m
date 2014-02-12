Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaBLKyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:54:32 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:58518 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaBLKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:54:29 -0500
Message-ID: <52FB52D7.4000906@atmel.com>
Date: Wed, 12 Feb 2014 11:54:15 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        <b.brezillon@overkiz.com>
CC: <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/8] at91: dt: Adds support for the bus matrix declaration
 in the DT
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com> <1392199607-27452-2-git-send-email-jjhiblot@traphandler.com> <52FB50BB.5070603@free-electrons.com>
In-Reply-To: <52FB50BB.5070603@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 11:45, Gregory CLEMENT :
> Hi Jean-Jacques,
> 
> Thanks for this new series, I have one little comment:
> 
> On 12/02/2014 11:06, Jean-Jacques Hiblot wrote:
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  arch/arm/mach-at91/setup.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
>> index f7ca97b..b8d0b66 100644
>> --- a/arch/arm/mach-at91/setup.c
>> +++ b/arch/arm/mach-at91/setup.c
>> @@ -487,6 +487,28 @@ end:
>>  	of_node_put(np);
>>  }
>>  
>> +static struct of_device_id matrix_ids[] = {
>> +	{ .compatible = "atmel,at91sam9261-bus-matrix", },
>> +	{ /*sentinel*/ }

I think that we can introduce this compatible string with sam9260
product: "atmel,at91sam9260-bus-matrix".

In addition, can you add this new binding in the documentation file:
Documentation/devicetree/bindings/arm/atmel-at91.txt
(in another patch with the "dt: bindings: " subject prefix + add the DT
mailing-list: devicetree@vger.kernel.org).


>> +};
>> +
>> +static void at91_dt_matrix(void)
>> +{
>> +	struct device_node *np;
>> +
>> +	np = of_find_matching_node(NULL, matrix_ids);
>> +	if (!np) {
>> +		pr_debug("AT91: unable to find compatible bus matrix controller node in dtb\n");
> 
> I think that a panic here should be more consistent with the next check.
> Indeed if it fails here then at91_matrix_base will be uninitialized too,
> and it will make the kernel crash when at91_matrix_base will be accessed.

Yes.

> Thanks,
> 
> Gregory
> 
> 
>> +		return;
>> +	}
>> +
>> +	at91_matrix_base = of_iomap(np, 0);
>> +	if (!at91_matrix_base)
>> +		panic("Impossible to ioremap at91_matrix_base\n");
>> +
>> +	of_node_put(np);
>> +}
>> +
>>  void __init at91rm9200_dt_initialize(void)
>>  {
>>  	at91_dt_ramc();
>> @@ -506,6 +528,7 @@ void __init at91_dt_initialize(void)
>>  	at91_dt_rstc();
>>  	at91_dt_ramc();
>>  	at91_dt_shdwc();
>> +	at91_dt_matrix();
>>  
>>  	/* Init clock subsystem */
>>  	at91_dt_clock_init();
>>
> 
> 


-- 
Nicolas Ferre
