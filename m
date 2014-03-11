Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaCKM2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:28:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13663 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaCKM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:28:21 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-90-531f01639ef1
Message-id: <531F0154.9040409@samsung.com>
Date: Tue, 11 Mar 2014 13:28:04 +0100
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
Subject: Re: [PATCH 3/5] ARM: dts: exynos4x12: Add GPS_ALIVE power domain
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-4-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394524494-30641-4-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rJjPLBBgtns1hc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxYHXY828NYweLc09bB4LPl9h91i5/Aubx+Yl9R59W1YxenzeJOexcW5oAEcUl01Kak5m
	WWqRvl0CV8bzNw/ZCpq5K3a2n2dpYOzj7GLk5JAQMJH48/ARM4QtJnHh3no2EFtIYCmjxIqd
	IhD2Z0aJPXdyQWxeAS2JvpYOsHoWAVWJe7P+g9WzCahJfG54BGaLCkRI/J23nhGiXlDix+R7
	LCC2iIC9xJ4HG4DiXBzMAjuZJPYs3ckEkhAW8JT4umMNWEJIoJFR4vrXOawgCU4BN4kpnefB
	ipgFrCVWTtrGCGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0
	veT83E2MkNj5soNx8TGrQ4wCHIxKPLwr/OWChVgTy4orcw8xSnAwK4nwXrwHFOJNSaysSi3K
	jy8qzUktPsTIxMEp1cBoF7vzdOvxzXsu6bk5r267fsyuxUlh+7647m/mSoeSmUM3Fim8SFlX
	ccz2ekFF6J2w1ZYl8+8tXD/z1axm5Xib/VtUDboFfk11f73McEnLuwvlS5Y8zY+yXnrDRlRe
	IPKOkz2fxLcysTeVTyv8/F3nSAua3Lfu0H1eejbmwLdH66z757k4BLxTYinOSDTUYi4qTgQA
	8gL/x3sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.03.2014 08:54, Chanwoo Choi wrote:
> This patch add GPS_ALIVE power domain for Exynos4x12 SoC. GPS_ALIVE power domain
> include GPS_BLK for GPS IP. Exynos SoC used generic power-domain driver to
> control power domain. After completed kernel booting, Exynos power-domain driver
> disable un-used power domain to reduce power-consumption/leak.
>
> If GPS_ALIVE power domain isn't registered to Exynos power-domain driver,
> happen power-leakage because GPS_ALIVE_CONFIGURATION is default power on state.
>
> - 0x10023D00 : GPS_ALIVE_CONFIGURATION register address
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
> index 1ec77f6..066eb35 100644
> --- a/arch/arm/boot/dts/exynos4x12.dtsi
> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> @@ -41,6 +41,11 @@
>   		compatible = "samsung,exynos4210-pd";
>   		reg = <0x10023CA0 0x20>;
>   	};
> +	
> +	pd_gps_alive: gps-alive-power-domain@10023D00 {
> +		compatible = "samsung,exynos4210-pd";
> +		reg = <0x10023D00 0x20>;
> +	};
>

Exynos4210 seems to have this power domain as well, so I guess this 
change should be done to exynos4.dtsi instead.

Best regards,
Tomasz
