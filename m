Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbaDILKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:10:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9882 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:10:39 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9c-53452aad8c66
Message-id: <53452AA9.2090002@samsung.com>
Date: Wed, 09 Apr 2014 13:10:33 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com
Subject: Re: [PATCH v4 2/5] dt: exynos5420: Enable support for USB 3.0 PHY
 controller
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-3-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xy7prtVyDDX4s4bM4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymZx4WkPm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCwW
	LWtltpj3eSeTA5/Hzll32T32z13D7rF5Sb1H35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjf
	LoErY8ezDywF/zkqDky+wtLAuJq9i5GTQ0LAROLgz/dQtpjEhXvr2boYuTiEBJYySiy985Ud
	wvnMKPHszxomkCpeAS2Jtl0gCQ4OFgFVieVnRUHCbAJqEp8bHrGB2PxAJWuarrOA2KICERL3
	Gg+zQrQKSvyYfI8FZKaIwE9GiXeNPWAJZoE+RonTJ2xBbGGBcInJdw4yQSxuZ5S4tOEg2CRO
	AU+JVwvuskE0WEusnLSNEcKWl9i85i3zBEbBWUiWzEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrF
	ibnFpXnpesn5uZsYIdH0ZQfj4mNWhxgFOBiVeHgVLF2ChVgTy4orcw8xSnAwK4nwPmdzDRbi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAmML7rNHw7oMjG804NkaIcIYFnbkXcs+908Fw3tWO9Ws6
	zRO1/JLmOjVFqWW9js01mHGrqHfX0q8JHz8vWZ6zYd65fwfXpf3eNptd5FxDR/Stdut11q5l
	Xj//eR3/cevnSktVrgdVTf/nnOS5yvXUe/bc+dYvThWfXHPdKsSGL+oI6yEP2+byrUosxRmJ
	hlrMRcWJAF8A0GSEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2014 16:36, Vivek Gautam wrote:
> Add device tree nodes for USB 3.0 PHY present alongwith
> USB 3.0 controller Exynos 5420 SoC. This phy driver is
> based on generic phy framework.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   arch/arm/boot/dts/exynos5420.dtsi |   20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 8db792b..a6efb52 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -652,4 +652,24 @@
>   		clocks = <&clock 319>, <&clock 318>;
>   		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>   	};
> +
> +	usbdrd_phy0: phy@12100000 {
> +		compatible = "samsung,exynos5420-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
> +		clock-names = "phy", "ref", "usb30_sclk_100m";

As I mentioned in another reply, please make sure that "usb30_sclk_100m" 
isn't simply a gate clock for "ref" clock.

Otherwise,

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
