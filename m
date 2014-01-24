Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaAXOKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:10:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35615 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaAXOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:10:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-25-52e27445735d
Message-id: <52E27436.5040908@samsung.com>
Date: Fri, 24 Jan 2014 15:09:58 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/8 v4] crypto:s5p-sss: Add support for SSS module on Exynos
References: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
 <1389777316-15070-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389777316-15070-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xy7quJY+CDNpnKVjcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxapdfxgtzs45xOTA5bFl5U0mj52z7rJ7
	bDug6tG3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZb6ZdYCy4zV1x7U8TcwPjTM4uRk4OCQET
	iY/7rzJB2GISF+6tZ+ti5OIQEljKKNG7YBMrhPOZUeL4ibVADgcHr4CWROfxIJAGFgFVid19
	69hBbDYBNYnPDY/YQGxRgQiJv/PWM4LYvAKCEj8m32MBsUUEyiX+3VgDtoBZ4CijxOc5F5lA
	ZgoLBEg82JYNsauRUeJAy0ywZk4BN4mp89aDXccsYC2xctI2RghbXmLzmrfMExgFZiHZMQtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihIT/lx2Mi49ZHWIU4GBU4uGdEfgw
	SIg1say4MvcQowQHs5II79aAR0FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGCXdPk7jTPjel1Fz
	/oRkxbEnS+707Cl5bP/BOurnhRWPzjw83LH+QvsKv1JLZ+mW59eatzoFr137dH39hL4et+23
	rvUk23A1MmbYmHu0B1odLjbIX954P8aNbf75Gqmo7jwpHba5V30eFwdN/h56If+LcY/R6n6W
	ZbsffUvYHjvLIvOXlrvyHCWW4oxEQy3mouJEALPgxixdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 15.01.2014 10:15, Naveen Krishna Chatradhi wrote:
> This patch adds new compatible and variant struct to support the SSS
> module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
> for which
> 1. AES register are at an offset of 0x200 and
> 2. hash interrupt is not available
[snip]
>   Required properties:
>
>   - compatible : Should contain entries for this and backward compatible
>     SSS versions:
>     - "samsung,s5pv210-secss" for S5PV210 SoC.
> +  - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
> +		Exynos5260 and Exynos5420 SoCs.
>   - reg : Offset and length of the register set for the module
>   - interrupts : the interrupt-specifier for the SSS module.
> -		Two interrupts "feed control and hash" in case of S5PV210
> -- clocks : the required gating clock for the SSS module.
> -- clock-names : the gating clock name to be requested in the SSS driver.
> +		-- Two interrupts "feed control and hash" in case of
> +		   "samsung,s5pv210-secss"
> +		-- One interrupts "feed control" in case of
> +		   "samsung,exynos4210-secss".
> +- clocks : list of clock phandle and specifier pairs for all clocks  listed in
> +		clock-names property.
> +- clock-names : list of device clock input names; should contain one entry
> +		"secss".

Hmm, I guess this is a rebase error, because this should rather be 
squashed with patch 2/8.

Otherwise the patch looks good to me.

Best regards,
Tomasz
