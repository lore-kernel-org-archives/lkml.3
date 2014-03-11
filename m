Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaCKMUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:20:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16803 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaCKMUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:20:32 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-19-531eff8d7830
Message-id: <531EFF7F.9010405@samsung.com>
Date: Tue, 11 Mar 2014 13:20:15 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH 1/5] ARM: dts: exynos4x12: Add ADC's dt data to read raw
 data
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394524494-30641-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xy7q9/+WCDVY1mVtc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxYHXY828NYweLc09bB4LPl9h91i5/Aubx+Yl9R59W1YxenzeJOexcW5oAEcUl01Kak5m
	WWqRvl0CV8bB7qNsBYt4Ku4t/MjawPiQs4uRk0NCwETi/7ybLBC2mMSFe+vZuhi5OIQEljJK
	zOnvZYVwPjNKrN78iw2kildAS2J+3w0mEJtFQFVi27X7rCA2m4CaxOeGR2A1ogIREn/nrWeE
	qBeU+DH5HtgGEQF7iT0PNjCCDGUW2MkksWfpTrBBwgLBEq827mSB2NbIKHH96X+wbk4BN4m+
	rtVgG5gFrCVWTtrGCGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi
	0rx0veT83E2MkPj5uoNx6TGrQ4wCHIxKPLwBvnLBQqyJZcWVuYcYJTiYlUR4L94DCvGmJFZW
	pRblxxeV5qQWH2Jk4uCUamDs/8bBk3HnSNgGMSceR9FaP1Wxhnfcx7tDC0r5y1buCtrh4GMb
	+XrXsb/OK/cmuWeysOturo4rnsjvI+Uxpcq7Z9OmolkdLvIiEbkKVxPc1f9WLd7ZYezGPEuq
	IdaH+1zFnbNSfxVeax/VdQioy5lZVCv1TvPaVr/QG9aa77c9WR2k76RVoMRSnJFoqMVcVJwI
	ABi8QBF9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.03.2014 08:54, Chanwoo Choi wrote:
> This patch add ADC(Analog to Digital Converter)'s dt data to get raw data
> with IIO subsystem. Usually, ADC is used to check temperature, jack type, and
> so on.
>

8< ---

> Register map
> - <0x126C0000 0x100> : ADC register's base address
> - <0x10020718 0x4> : ADC_PHY_CONTROL, TS-ADC control register address
>
> Clock
> - <&clock 326> : ADC clock (clock name :'tsadc')
>
> Interrupt
> - INTG10[3] : ADC for General ADC

--- >8

I don't think there is a need to include such data in commit message. A 
commit message should say what is done and why it's done (and sometimes 
how it's done, in case of some complex code being added) and I guess 
that's all.

>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4x12.dtsi | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
> index 5c412aa..5a3e551 100644
> --- a/arch/arm/boot/dts/exynos4x12.dtsi
> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> @@ -80,6 +80,18 @@
>   		};
>   	};
>
> +	adc: adc@126C0000 {
> +		compatible = "samsung,exynos-adc-v1";
> +		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +		interrupt-parent = <&combiner>;
> +		interrupts = <10 3>;
> +		clocks = <&clock 326>;

Please use clock macros instead of numbers, as introduced by Andrzej 
Hajda's patches merged to Kgene's tree.

Best regards,
Tomasz
