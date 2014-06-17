Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbaFQROh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:14:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37603 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933460AbaFQROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:14:36 -0400
Date: Tue, 17 Jun 2014 18:13:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "haifeng.yan@linaro.org" <haifeng.yan@linaro.org>,
        "jchxue@gmail.com" <jchxue@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Message-ID: <20140617171357.GH8930@leverpostej>
References: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
 <1402991881-27676-2-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402991881-27676-2-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 08:58:00AM +0100, Zhangfei Gao wrote:
> From: Jiancheng Xue <xuejiancheng@huawei.com>
> 
> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
> 
> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  .../devicetree/bindings/phy/hix5hd2-sata-phy.txt   |   26 ++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
> new file mode 100644
> index 0000000..ed15123
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
> @@ -0,0 +1,26 @@
> +Hisilicon hix5hd2 SATA PHY
> +-----------------------
> +
> +Required properties:
> +- compatible: should be "hisilicon,hix5hd2-sata-phy"
> +- reg: offset and length of the PHY registers
> +- #phy-cells: must be 0
> +Refer to phy/phy-bindings.txt for the generic PHY binding properties
> +
> +Optional Properties:
> +- hisilicon,peri-syscon: phandle of syscon used to control peripheral.

"peri" is a rather strange contraction of "peripheral".

> +- hisilicon,power-reg: offset and bit number of the sata power supply register.
> +  Only effective when hisilicon,peri-syscon is supplied.

This is the offset within the system controller? It would be good to
state that.

> +- hisilicon,reg-init: one of more sets of 4 cells.  The first cell
> +  is the register offset address, the second cell is the start bit in register,
> +  the third cell means the bit width, and the fourth cell is the value to set.

Which registers is this meant to be initialising?

Why does this need to be in the DT? How much is this expected to vary?

Mark.
