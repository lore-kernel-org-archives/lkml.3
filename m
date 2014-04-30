Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbaD3Lfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:35:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50143 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbaD3Lfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:35:40 -0400
Message-ID: <5360EBD0.80704@ti.com>
Date: Wed, 30 Apr 2014 15:25:52 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <prabhakar.csengg@gmail.com>,
        <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v2 1/4] mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
References: <1397841897-9170-1-git-send-email-grygorii.strashko@ti.com> <1397841897-9170-2-git-send-email-grygorii.strashko@ti.com> <53516650.3000405@cogentembedded.com>
In-Reply-To: <53516650.3000405@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 08:52 PM, Sergei Shtylyov wrote:
> On 04/18/2014 09:24 PM, Grygorii Strashko wrote:
> 
>> Add a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
>> to automatically clean up MDIO bus alocations made by MDIO drivers,
>> thus leading to simplified MDIO drivers code.
> 
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> [...]
> 
>> index 76f54b3..6412beb 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -69,6 +69,74 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
> [...]
>> +/**
>> + * devm_mdiobus_alloc - Resource-managed mdiobus_alloc_size()
>> + * @dev:        Device to allocate mii_bus for
>> + * @sizeof_priv:    Space to allocate for private structure.
>> + *
>> + * Managed mdiobus_alloc_size. mii_bus allocated with this function is
>> + * automatically freed on driver detach.
>> + *
>> + * If an mii_bus allocated with this function needs to be freed 
>> separately,
>> + * devm_mdiobus_free() must be used.
>> + *
>> + * RETURNS:
>> + * Pointer to allocated mii_bus on success, NULL on failure.
>> + */
>> +struct mii_bus *devm_mdiobus_alloc(struct device *dev, int sizeof_priv)
>> +{
>> +    struct mii_bus **ptr, *bus;
>> +
>> +    ptr = devres_alloc(_devm_mdiobus_free, sizeof(*ptr),
>> +               GFP_KERNEL);
>> +    if (!ptr)
>> +        return NULL;
>> +
>> +    /* use raw alloc_dr for kmalloc caller tracing */
>> +    bus = mdiobus_alloc_size(sizeof_priv);
> 
>     Since the wrapped function is called mdiobus_alloc_size(), not 
> mdiobus_alloc(), perhaps it's better to call the wrapper 
> devm_mdiobus_alloc_size()?

Agree. I've just sent v3.

Regards,
-grygorii

