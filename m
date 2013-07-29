Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3G2P3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:29:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23471 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3G2P3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:29:11 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-97-51f68a440636
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, gregkh@linuxfoundation.org,
        kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, kgene.kim@samsung.com,
        stern@rowland.harvard.edu, broonie@kernel.org, tomasz.figa@gmail.com,
        arnd@arndb.de
Cc: grant.likely@linaro.org, tony@atomide.com, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com,
        linux@arm.linux.org.uk, Tomasz Figa <t.figa@samsung.com>
References: <1374842963-13545-1-git-send-email-kishon@ti.com>
 <1374842963-13545-2-git-send-email-kishon@ti.com>
In-reply-to: <1374842963-13545-2-git-send-email-kishon@ti.com>
Subject: RE: [RESEND PATCH v10 1/8] drivers: phy: add generic PHY framework
Date: Mon, 29 Jul 2013 17:28:18 +0200
Message-id: <023801ce8c70$427cbd20$c7763760$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6J/1ZtM1Gf5eDvTleme+JQqt4sBACb5ClA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUhTYRjHec/XjuLkNE3eRA0FqQxNRegtRLxIOBlBIl0UQS4dajqdOyoa
	iiOXqzl1uESZlpqmspTZVkwlv1Y4c32IKzPKSV+KqSGUZk6ztt3s7vf8ef4/nouHxgV/iEA6
	O69QJM0T5oZR3oT1r8UWeUq5mRK9VBWPWvS9FNqtn+ChBo2JQuMLFajh01cKtT57RaKp8W4S
	je0MAFTZoaeQrX2GRDVtbyk0/U1FoZfXV3nI8GWWRO1VnQSarF0nkW2ohUKq/sckau6sI1DT
	6xEM3eu6gaMPNj4arenH0NNVBYnUjmkKzTXKSaRvWiGQbmgHoNE3yYnBrLxSRbGO7XrAbm7U
	E+ygdp7HGnS3KPbj7BOKnWxyEOzonV4ea+ysYGsqf1Bs8/wWYGsf6QBrmTNh7E9DyDnfi97x
	GaLc7GKR9FhCmnfWWo+VlJgOlMjrFjEZ2BAogRcNmTj4vGsbuDkATtv1lBJ40wLmPoBTMgVw
	DzIMLivrcCWgaYo5AnV21pn7M90YHFHoXA2cWcGh1djIc6oETAHc3etxab2YBHh3dsDFfswZ
	2Krvo5xMMOFQXm13MZ9JhBuaatzN++CWxk44GWcioH7Qgrn5IDT2rrmOgMwh+Hk30hn7M7Hw
	Zv93nnvFH87Llkg1EGg9TFoPk9bDpPWotAFCB/aLitIl3JVMcUwUJxRzRXmZUen5YgNwv8uv
	AdAxcdIMGBqE+fC9uM0UASks5krFZgBpPMyfP5f8P+JnCEuviaT5l6VFuSLODDDaK1AG9MTt
	clJmyYmWmJiWtbIhLPXd4Z04H3FfeKHVkjPxUGgMXb9U6jtTOPUi1WG2n46uKkg6KukaWBye
	VJfEaQLKmspT8Auhy4HJ1vKOpBFNsOHqecUJrWQszhQxPDX8eykWhrzfjPA7bo5XSzr2FNuc
	6kFa0IJFSJ9N0Qctx4YRXJYwJgKXcsJ/uxyOXwwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

A small fix follows inline.

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Kishon Vijay Abraham I
> Sent: Friday, July 26, 2013 2:49 PM
> 
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference
> to the PHY with or without using phandle. For dt-boot, the PHY drivers
> should also register *PHY provider* with the framework.
> 
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
> 
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found
> at Documentation/devicetree/bindings/phy/phy-bindings.txt
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../devicetree/bindings/phy/phy-bindings.txt       |   66 ++
>  Documentation/phy.txt                              |  166 +++++
>  MAINTAINERS                                        |    8 +
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    2 +
>  drivers/phy/Kconfig                                |   18 +
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |  714
> ++++++++++++++++++++
>  include/linux/phy/phy.h                            |  270 ++++++++
>  9 files changed, 1251 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-
> bindings.txt
>  create mode 100644 Documentation/phy.txt  create mode 100644
> drivers/phy/Kconfig  create mode 100644 drivers/phy/Makefile  create
> mode 100644 drivers/phy/phy-core.c  create mode 100644
> include/linux/phy/phy.h
> 

[snip]

> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h new file
> mode 100644 index 0000000..e444b23
> --- /dev/null
> +++ b/include/linux/phy/phy.h
> @@ -0,0 +1,270 @@

[snip]

> +struct phy_init_data {
> +	unsigned int num_consumers;
> +	struct phy_consumer *consumers;
> +};
> +
> +#define PHY_CONSUMER(_dev_name, _port)				\
> +{								\
> +	.dev_name	= _dev_name,				\
> +	.port		= _port,				\
> +}
> +
> +#define	to_phy(dev)	(container_of((dev), struct phy, dev))
> +
> +#define	of_phy_provider_register(dev, xlate)	\
> +	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
> +
> +#define	devm_of_phy_provider_register(dev, xlate)	\
> +	__of_phy_provider_register((dev), THIS_MODULE, (xlate))

I think this should be:
+	__devm_of_phy_provider_register((dev), THIS_MODULE, (xlate))
Right?

> +
> +static inline void phy_set_drvdata(struct phy *phy, void *data) {
> +	dev_set_drvdata(&phy->dev, data);
> +}
> +
> +static inline void *phy_get_drvdata(struct phy *phy) {
> +	return dev_get_drvdata(&phy->dev);
> +}
> +

[snip]

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland




