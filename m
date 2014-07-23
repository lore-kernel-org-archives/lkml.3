Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbaGWHDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:03:40 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40200 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbaGWHDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:03:38 -0400
Message-ID: <53CF5E4A.8050306@gmail.com>
Date: Wed, 23 Jul 2014 15:03:38 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zhou Wang <wangzhou.bry@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        caizhiyong@huawei.com
Subject: Re: [PATCH v1 3/3] mtd: hisilicon: add device tree binding documentation
References: <1405421906-660-1-git-send-email-wangzhou.bry@gmail.com> <1405421906-660-4-git-send-email-wangzhou.bry@gmail.com>
In-Reply-To: <1405421906-660-4-git-send-email-wangzhou.bry@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月15日 18:58, Zhou Wang wrote:
> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
> ---
>   .../devicetree/bindings/mtd/hisi-nand.txt          |   40 ++++++++++++++++++++
>   1 file changed, 40 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mtd/hisi-nand.txt
>

Hi Randy Dunlap,

Is there anything that should be modified about this binding document? 
It would be very appreciated that I could get some comments from you.

Best regards,
Zhou

> diff --git a/Documentation/devicetree/bindings/mtd/hisi-nand.txt b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
> new file mode 100644
> index 0000000..c8b3988
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
> @@ -0,0 +1,40 @@
> +Hisilicon Hip04 Soc NAND controller DT binding
> +
> +Required properties:
> +- compatible:          Should be "hisilicon,504-nfc".
> +- reg:                 The first contains base physical address and size of
> +                       NAND controller's registers. The second contains base
> +                       physical address and size of NAND controller's buffer.
> +- interrupts:          Interrupt number for nfc.
> +- nand-bus-width:      See nand.txt.
> +- nand-ecc-mode:       See nand.txt.
> +- hisi,nand-ecc-bits:  ECC bits type support.
> +                 <0>:  none ecc
> +                 <1>:  Can correct 1bit per 512byte.
> +                 <6>:  Can correct 16bits per 1K byte.
> +- #address-cells:      partition address, should be set 1.
> +- #size-cells:         partition size, should be set 1.
> +
> +Flash chip may optionally contain additional sub-nodes describing partitions of
> +the address space. See partition.txt for more detail.
> +
> +Example:
> +
> +	nand: nand@4020000 {
> +		compatible = "hisilicon,504-nfc";
> +		reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
> +		interrupts = <0 379 4>;
> +		nand-bus-width = <8>;
> +		nand-ecc-mode = "hw";
> +		hisi,nand-ecc-bits = <1>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +
> +		partition@0 {
> +			label = "nand_text";
> +			reg = <0x00000000 0x00400000>;
> +		};
> +
> +		...
> +
> +	};
>

