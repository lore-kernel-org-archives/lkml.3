Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaEFNlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:41:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbaEFNlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:41:04 -0400
Message-ID: <5368E658.1040209@ti.com>
Date: Tue, 6 May 2014 08:40:40 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>
Subject: Re: [TEMP PATCH 17/17] ARM: dts: dra7: Add *resets* property for
 PCIe dt node
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-18-git-send-email-kishon@ti.com>
In-Reply-To: <1399383244-14556-18-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 08:34 AM, Kishon Vijay Abraham I wrote:
> Added *resets* and *reset-names* properies for PCIe dt node.
> The documention for this node can be found @ ../bindings/pci/ti-pci.txt.
>
> Cc: Dan Murphy <dmurphy@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 20b1a09..7bc0555 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -1031,6 +1031,8 @@
>  			ti,hwmods = "pcie1";
>  			phys = <&pcie1_phy>;
>  			phy-names = "pcie-phy";
> +			resets = <&prm_resets &device_reset>;

If you look @ v2 of the reset framework patchset your phandle should be

resets = <&prm_resets &pcie1_reset>;

If you call the device_reset phandle you will reset the SoC.


> +			reset-names = "reset";

This needs to be more descriptive.

>  		};
>  
>  		sata: sata@4a141100 {


-- 
------------------
Dan Murphy

