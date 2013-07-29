Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3G2Pbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:31:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43183 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab3G2Pbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:31:44 -0400
Message-ID: <51F68AB2.5090402@ti.com>
Date: Mon, 29 Jul 2013 21:00:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <jg1.han@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>,
        <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [RESEND PATCH v10 1/8] drivers: phy: add generic PHY framework
References: <1374842963-13545-1-git-send-email-kishon@ti.com> <1374842963-13545-2-git-send-email-kishon@ti.com> <023801ce8c70$427cbd20$c7763760$%debski@samsung.com>
In-Reply-To: <023801ce8c70$427cbd20$c7763760$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013 08:58 PM, Kamil Debski wrote:
> Hi Kishon,
> 
> A small fix follows inline.
> 
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Kishon Vijay Abraham I
>> Sent: Friday, July 26, 2013 2:49 PM
>>
>> The PHY framework provides a set of APIs for the PHY drivers to
>> create/destroy a PHY and APIs for the PHY users to obtain a reference
>> to the PHY with or without using phandle. For dt-boot, the PHY drivers
>> should also register *PHY provider* with the framework.
>>
>> PHY drivers should create the PHY by passing id and ops like init, exit,
>> power_on and power_off. This framework is also pm runtime enabled.
>>
>> The documentation for the generic PHY framework is added in
>> Documentation/phy.txt and the documentation for dt binding can be found
>> at Documentation/devicetree/bindings/phy/phy-bindings.txt
>>
>> Cc: Tomasz Figa <t.figa@samsung.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  .../devicetree/bindings/phy/phy-bindings.txt       |   66 ++
>>  Documentation/phy.txt                              |  166 +++++
>>  MAINTAINERS                                        |    8 +
>>  drivers/Kconfig                                    |    2 +
>>  drivers/Makefile                                   |    2 +
>>  drivers/phy/Kconfig                                |   18 +
>>  drivers/phy/Makefile                               |    5 +
>>  drivers/phy/phy-core.c                             |  714
>> ++++++++++++++++++++
>>  include/linux/phy/phy.h                            |  270 ++++++++
>>  9 files changed, 1251 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/phy-
>> bindings.txt
>>  create mode 100644 Documentation/phy.txt  create mode 100644
>> drivers/phy/Kconfig  create mode 100644 drivers/phy/Makefile  create
>> mode 100644 drivers/phy/phy-core.c  create mode 100644
>> include/linux/phy/phy.h
>>
> 
> [snip]
> 
>> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h new file
>> mode 100644 index 0000000..e444b23
>> --- /dev/null
>> +++ b/include/linux/phy/phy.h
>> @@ -0,0 +1,270 @@
> 
> [snip]
> 
>> +struct phy_init_data {
>> +	unsigned int num_consumers;
>> +	struct phy_consumer *consumers;
>> +};
>> +
>> +#define PHY_CONSUMER(_dev_name, _port)				\
>> +{								\
>> +	.dev_name	= _dev_name,				\
>> +	.port		= _port,				\
>> +}
>> +
>> +#define	to_phy(dev)	(container_of((dev), struct phy, dev))
>> +
>> +#define	of_phy_provider_register(dev, xlate)	\
>> +	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
>> +
>> +#define	devm_of_phy_provider_register(dev, xlate)	\
>> +	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
> 
> I think this should be:
> +	__devm_of_phy_provider_register((dev), THIS_MODULE, (xlate))
> Right?

right.. thanks for spotting this.

Regards
Kishon
