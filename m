Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaDRRsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:48:30 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37854 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaDRRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:48:27 -0400
Message-ID: <5351656C.6070108@cogentembedded.com>
Date: Fri, 18 Apr 2014 21:48:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, prabhakar.csengg@gmail.com,
        santosh.shilimkar@ti.com, Sekhar Nori <nsekhar@ti.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v2 1/4] mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
References: <1397841897-9170-1-git-send-email-grygorii.strashko@ti.com> <1397841897-9170-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1397841897-9170-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/18/2014 09:24 PM, Grygorii Strashko wrote:

> Add a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
> to automatically clean up MDIO bus alocations made by MDIO drivers,
> thus leading to simplified MDIO drivers code.

> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
[...]

> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 76f54b3..6412beb 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -69,6 +69,74 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
[...]
> +/**
> + * devm_mdiobus_free - Resource-managed mdiobus_free()
> + * @dev:		Device this mii_bus belongs to
> + * @bus:		the mii_bus associated with the device
> + *
> + * Free mii_bus allocated with devm_mdiobus_alloc().
> + */
> +void devm_mdiobus_free(struct device *dev, struct mii_bus *bus)
> +{
> +	int rc;
> +
> +	rc = devres_release(dev, _devm_mdiobus_free,
> +		devm_mdiobus_match, bus);

    Please re-align this line, so that it starts right under 'dev' on the 
previous line.

WBR, Sergei

