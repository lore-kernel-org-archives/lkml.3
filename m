Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaDHJA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:00:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53124 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:00:56 -0400
Message-ID: <5343C6C5.2050502@ti.com>
Date: Tue, 8 Apr 2014 12:52:05 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-doc@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 1/2] mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
References: <1396618825-4241-1-git-send-email-grygorii.strashko@ti.com> <1396618825-4241-2-git-send-email-grygorii.strashko@ti.com> <533EB077.6000005@cogentembedded.com>
In-Reply-To: <533EB077.6000005@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 04:15 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 04-04-2014 17:40, Grygorii Strashko wrote:
>
>> Add a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
>> to automatically clean up MDIO bus alocations made by MDIO drivers,
>> thus leading to simplified MDIO drivers code.
>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> [...]
>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 76f54b3..fdcd6d1 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -69,6 +69,74 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
>>   }
>>   EXPORT_SYMBOL(mdiobus_alloc_size);
>>
>> +static void _devm_mdiobus_free(struct device *dev, void *res)
>> +{
>> +    mdiobus_free(*(struct mii_bus **)res);
>> +}
>> +
>> +static int devm_mdiobus_match(struct device *dev, void *res, void *data)
>> +{
>> +    struct mii_bus **r = res;
>
>     Please insert an empty line after declaration.
>
>> +    if (!r || !*r) {
>> +        WARN_ON(!r || !*r);
>
>     Hm, why we need the duplicate check This condition is always true.

It can be replaced with:
	if (WARN_ON(!r || !*r))
		return 0;


I will wait for additional comments, then resend.

Regards,
- grygorii

