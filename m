Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3IWMhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:37:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23882 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3IWMhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:37:35 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d1-5240360df660
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] DT: if dt is available don't use s3c_arch_init
Date: Mon, 23 Sep 2013 14:37:22 +0200
Message-id: <2025079.MVbFYJdokX@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xq7q8Zg5BBme7TC0mrTvAZNG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rU4veYUs8XaI3fZHTg9Wpp72Dz+rnrB7LF5Sb3H
	wXd7mDz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr4/elm4wFU7kqln7oYW9gXMbRxcjJISFg
	IrHj/zQ2CFtM4sK99UA2F4eQwFJGiWn3v7FAOF1MEt9ONDKCVLEJqEl8bngE1iEiYCrx7u41
	sA5mgR+MEuv2zWcGSQgLOEusf/4NzGYRUJX4MG8nWAOvgKbE6SM/wOL8AuoS77Y9ZQKxRQVc
	JT4t3MgOYnMK+Esc6rkKVi8k4Cext3EKC0SvoMSPyffAbGYBeYl9+6eyQthaEut3HmeawCg4
	C0nZLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREhtfdjAuPmZ1iFGAg1GJ
	hzci0T5IiDWxrLgy9xCjBAezkgjvIkWHICHelMTKqtSi/Pii0pzU4kOMTBycUg2M/RMFxS4U
	2bAIpp1g/eGw/W3R+eBXER/iejq0egq2e83g1dz1Jfp0uozET9kDNgJrrkuyPG10mMa9nIHr
	/cs/F0sKj+6zc+K8dKh2ff97lvvzz869JlmmKev4W90iR/dMXvuWCaGr5Ri8nt/vXZpUeT2+
	INb1d8K21Ok/WHmYAn1er/1dvqZciaU4I9FQi7moOBEA9To7zWsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Monday 23 of September 2013 12:14:49 Mateusz Krawczuk wrote:
> It prevents from executing platform code, when booting from device tree.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/plat-samsung/init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
> index aa9511b..0ace02d 100644
> --- a/arch/arm/plat-samsung/init.c
> +++ b/arch/arm/plat-samsung/init.c
> @@ -20,6 +20,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/ioport.h>
> +#include <linux/of.h>
>  #include <linux/serial_core.h>
>  #include <linux/platform_device.h>
>  #include <linux/of.h>
> @@ -152,6 +153,8 @@ static int __init s3c_arch_init(void)
>  {
>  	int ret;
> 
> +	if (of_have_populated_dt())
> +		return 0;

I'm not sure if this is the correct thing to do here (note platforms that 
still want this initialization to be handled, even when booting with DT).

The DT case is already handled several lines below in if (cpu == NULL) 
check and if your platform requires this initialization not to happen you 
should assure it has cpu == NULL.

Best regards,
Tomasz

