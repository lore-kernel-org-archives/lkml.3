Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbaCSMT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:19:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16380 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:19:55 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-78-53298b683478
Message-id: <53298B63.40005@samsung.com>
Date: Wed, 19 Mar 2014 13:19:47 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/4] clk: samsung: add new Kconfig for Samsung common
 clock options
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1394598781-3848-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1394598781-3848-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7oZ3ZrBBmfvaVpsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFuRzN7wS2OiokN
	/UwNjP3sXYycHBICJhJTF9xihLDFJC7cW88GYgsJLGWUeLDWFML+zCjRvywExOYV0JB4fqQd
	rJ5FQFWi88BcJhCbTUBN4nPDI7BefgEtiTVN11lAbFGBCIm5EzezQfQKSvyYfA8ozsUhIjCN
	UeL6jEawI4QFYiQaNn1nBEkICbQySrx/9ghsKqeAh8TdAx/AipgFrCVWTtrGCGHLS2xe85Z5
	AqPALCSDZyEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkJD9uoNx6TGrQ4wC
	HIxKPLwSsRrBQqyJZcWVuYcYJTiYlUR4D9VrBgvxpiRWVqUW5ccXleakFh9iZOLglGpgLDNZ
	f9bLmTfJqTwvUy8rbxtrWvCX/sJN+7JyT1s9VryXlB/msOffjxXZt6tUjaaKcOrsj398mPOY
	lvG73xa7rj9JtLEUPfvmZlpGSK6H8IKq9mnLn5RVX5Je5az+n3PX/3rdU/M/aew21Jt3wWHG
	33UG85Y7Tbvz8P+v66dMso4+nvy5JdbjjxJLcUaioRZzUXEiAJ02mvI3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12.03.2014 05:32, Pankaj Dubey wrote:
> This patch adds new Kconfig file for adding new config option
> as COMMON_CLK_SAMSUNG for Samsung common clock. This patch also
> moves S3C24XX specific clock options here in this file.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/samsung/Kconfig |   11 +++++++++++
>   1 file changed, 11 insertions(+)
>   create mode 100644 drivers/clk/samsung/Kconfig
>
> diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
> new file mode 100644
> index 0000000..26eb446
> --- /dev/null
> +++ b/drivers/clk/samsung/Kconfig
> @@ -0,0 +1,11 @@
> +config COMMON_CLK_SAMSUNG
> +	bool
> +	select COMMON_CLK
> +
> +config S3C2412_COMMON_CLK
> +	bool
> +	select COMMON_CLK_SAMSUNG
> +
> +config S3C2443_COMMON_CLK
> +	bool
> +	select COMMON_CLK_SAMSUNG
>

This patch adds S3C2412_COMMON_CLK and S3C2443_COMMON_CLK to 
drivers/clk/samsung/Kconfig, but they are still present in 
arch/arm/mach-s3c24xx/Kconfig, so after this patch there are duplicate 
definitions.

Best regards,
Tomasz
