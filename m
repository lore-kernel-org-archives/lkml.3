Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbbAVMZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:25:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8464 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbAVMZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:25:18 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c7-54c0eb9a7bab
Message-id: <54C0EC23.9070209@samsung.com>
Date: Thu, 22 Jan 2015 13:25:07 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inha Song <ideal.song@samsung.com>, alsa-devel@alsa-project.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, robh+dt@kernel.org, kgene@kernel.org,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 3/4] ARM: dts: set clock out parent to
 XUSBXTI
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
 <1421925482-15861-4-git-send-email-ideal.song@samsung.com>
In-reply-to: <1421925482-15861-4-git-send-email-ideal.song@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xa7qzXh8IMZhxRs/iysVDTBZTHz5h
	s5h/5ByrRf+bhawWB/7sYLTY9fc+o8W5VysZLfofv2a2+Halg8li0+NrrBaXd81hs5hxfh+T
	xe3LvBZLr19kspgwfS2LReveI+wWF1d8YbJ4ufkNk4OQx4bPTWwea+atYfRoae5h87jc18vk
	sXPWXXaPlcu/sHlsWtXJ5nHn2h42j81L6j36tqxi9Nh8utrj8ya5AJ4oLpuU1JzMstQifbsE
	rozFXRdYCk6xV1x+9oi9gXEmWxcjJ4eEgInE4ldzoWwxiQv31gPZXBxCAksZJfbMnMkK4Xxi
	lHjXdBfI4eDgFdCSWL4qCaSBRUBVYumzz0wgNpuAoUTv0T5GEFtUIELi5N097CA2r4CgxI/J
	91hAWkUEnCX+9WWBhJkFJjFL/J6aCRIWFgiReDlRD2JTM6PElRUXGUHinALuEl/mg5nMAnoS
	9y9qQXTKS2xe85Z5AqPALCTzZyFUzUJStYCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZG
	SCx+3cG49JjVIUYBDkYlHt6IDQdChFgTy4orcw8xSnAwK4nw8r8ECvGmJFZWpRblxxeV5qQW
	H2Jk4uCUamAs4t64k23SnGWyb4Pf9hZqrFk6iW9zUHyj5cbyHQ0vdR9M85u4tNnUfbP3RBOP
	vBlrC1bsZF3D96SF95gY158446L0TxomUkZPsmdtsos5fvLbbkvVwgdu28WmVEUHOO+cOlP+
	1of8/Ad9Kl8a9Rev1bnIeO+wScSc2fxhb/YcqeSPuX1loWOPEktxRqKhFnNRcSIAQVs8oaMC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 12:18, Inha Song wrote:
> This patch set clock out parent to XUSBXTI.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index b8168f1..020bbaf 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -141,6 +141,8 @@
>  	pmu_system_controller: system-controller@10020000 {
>  		compatible = "samsung,exynos4210-pmu", "syscon";
>  		reg = <0x10020000 0x4000>;
> +		assigned-clocks = <&pmu_system_controller 0>;
> +		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
>  	};

Looks good, except it needs to be done only for the Trats2 board, i.e.
the PMU device node including these properties should be added to
exynos4412-trats2.dts.  I think it's fine to make it a one patch including
all dts changes.


-- 
Regards,
Sylwester
