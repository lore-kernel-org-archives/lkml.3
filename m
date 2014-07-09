Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaGIHM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:12:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30100 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGIHM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:12:27 -0400
Message-ID: <53BCEA77.2080004@huawei.com>
Date: Wed, 9 Jul 2014 09:08:39 +0200
From: Jerome FORISSIER <jerome.forissier@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Zhou Wang <wangzhou.bry@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <caizhiyong@huawei.com>, <wangzhou1@hisilicon.com>
Subject: Re: [PATCH 1/3] mtd: hisilicon: add device tree node for nand controller
References: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com> <1404115409-20200-2-git-send-email-wangzhou.bry@gmail.com>
In-Reply-To: <1404115409-20200-2-git-send-email-wangzhou.bry@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.122.142.65]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-Jun-14 10:03, Zhou Wang wrote:
> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
> ---
>  arch/arm/boot/dts/hip04.dtsi |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/hip04.dtsi b/arch/arm/boot/dts/hip04.dtsi
> index abb42ca..e63fc61 100644
> --- a/arch/arm/boot/dts/hip04.dtsi
> +++ b/arch/arm/boot/dts/hip04.dtsi
> @@ -386,5 +386,36 @@
>  				interrupts = <0 389 4>;
>  			};
>  		};
> +
> +		nand: nand@4020000 {
> +			compatible = "hisilicon,504-nfc";

In PATCH 2/3 and 3/3 you are using "hisilicon,nfc504".

> +			reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
> +			interrupts = <0 379 4>;
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "none";
> +			hisi,nand-ecc-bits = <0>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +
> +			partition@0 {
> +				label = "nand_text";
> +				reg = <0x00000000 0x00400000>;
> +			};
> +
> +			partition@00400000 {
> +				label = "nand_monitor";
> +				reg = <0x00400000 0x00400000>;
> +			};
> +
> +			partition@00800000 {
> +				label = "nand_kernel";
> +				reg = <0x00800000 0x00800000>;
> +			};
> +
> +			partition@01000000 {
> +				label = "nand_fs";
> +				reg = <0x01000000 0x1f000000>;
> +			};
> +		};
>  	};
>  };
> 

-- 
Jerome
