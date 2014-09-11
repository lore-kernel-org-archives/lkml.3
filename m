Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaIKQ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:29:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaIKQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:29:56 -0400
Message-ID: <5411CDFF.2000601@atmel.com>
Date: Thu, 11 Sep 2014 18:29:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/7] irqchip: atmel-aic5: Add sama5d4 support
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com> <1410450852-1834-2-git-send-email-alexandre.belloni@free-electrons.com> <5411CB17.1060608@atmel.com> <20140911162836.GB3131@piout.net>
In-Reply-To: <20140911162836.GB3131@piout.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 18:28, Alexandre Belloni :
> On 11/09/2014 at 18:17:27 +0200, Nicolas Ferre wrote :
>> On 11/09/2014 17:54, Alexandre Belloni :
>>> Add sama5d4 support to irq-atmel-aic5.
>>>
>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>> ---
>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>
>> Supposed to be before the "---" ;-)
> 
> This actually depends on the maintainer preferences, after the ---
> marker means that it will not appear in the final commit log which was
> my intention.

And it still works with git send-email? good to know! (and sorry for the
noise ;-)).

>>
>>>  drivers/irqchip/irq-atmel-aic5.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
>>> index dc7d98607a89..a11aae8fb006 100644
>>> --- a/drivers/irqchip/irq-atmel-aic5.c
>>> +++ b/drivers/irqchip/irq-atmel-aic5.c
>>> @@ -295,6 +295,7 @@ static void __init sama5d3_aic_irq_fixup(struct device_node *root)
>>>  
>>>  static const struct of_device_id __initdata aic5_irq_fixups[] = {
>>>  	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
>>> +	{ .compatible = "atmel,sama5d4", .data = sama5d3_aic_irq_fixup },
>>>  	{ /* sentinel */ },
>>>  };
>>>  
>>> @@ -349,3 +350,12 @@ static int __init sama5d3_aic5_of_init(struct device_node *node,
>>>  	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
>>>  }
>>>  IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
>>> +
>>> +#define NR_SAMA5D4_IRQS		68
>>> +
>>> +static int __init sama5d4_aic5_of_init(struct device_node *node,
>>> +				       struct device_node *parent)
>>> +{
>>> +	return aic5_of_init(node, parent, NR_SAMA5D4_IRQS);
>>> +}
>>> +IRQCHIP_DECLARE(sama5d4_aic5, "atmel,sama5d4-aic", sama5d4_aic5_of_init);
>>>
>>
>>
>> -- 
>> Nicolas Ferre
> 


-- 
Nicolas Ferre
