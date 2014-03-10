Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaCJN3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:29:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaCJN3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:29:05 -0400
Message-ID: <531DBE03.2070603@ti.com>
Date: Mon, 10 Mar 2014 15:28:35 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2 1/8] ARM: dts: dra7: Initialize USB_DPLL
References: <1394197751-28984-2-git-send-email-rogerq@ti.com> <1394455761-19226-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1394455761-19226-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 02:49 PM, Roger Quadros wrote:
> USB_DPLL must be initialized and locked at boot so that
> USB modules can work.
>
> Program USB_DLL_M2 output to half rate as well.
>
> Patch depends on
> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg101300.html
>
> CC: Mike Turquette <mturquette@linaro.org>
> CC: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/boot/dts/dra7.dtsi | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 597979b..f376923 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -815,3 +815,11 @@
>   };
>
>   /include/ "dra7xx-clocks.dtsi"
> +
> +&dpll_usb_ck {
> +        default-rate = <960000000>;
> +};
> +
> +&dpll_usb_m2_ck {
> +	default-rate = <480000000>;
> +};
>

You can add these directly under the dra7xx-clocks.dtsi file as well, as 
I don't think anybody needs to modify these. And the properties can be 
added directly under the nodes themselves.

However, this patch can't be acked yet as we have no feedback from Mike 
for the default-rate proposal.

-Tero

