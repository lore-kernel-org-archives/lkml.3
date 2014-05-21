Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaEUSS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:18:58 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65037 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEUSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:18:56 -0400
Message-ID: <537CEE13.5040908@cogentembedded.com>
Date: Wed, 21 May 2014 22:18:59 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, santosh.shilimkar@ti.com
CC: devicetree@vger.kernel.org, grygorii.strashko@ti.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, m-karicheri2@ti.com, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch] ARM: dts: keystone: add pll controller syscon entry
References: <1400681875-24432-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1400681875-24432-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/21/2014 06:17 PM, Ivan Khoronzhuk wrote:

> The pll controller register set includes sets of registers with
> different purposes, so it's logically to add syscon entry to be able
> to access them from appropriate places.

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---

> Based on linux-next/master

>   arch/arm/boot/dts/keystone.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)

> diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
> index d9f99e7..5e67c5b 100644
> --- a/arch/arm/boot/dts/keystone.dtsi
> +++ b/arch/arm/boot/dts/keystone.dtsi
> @@ -66,6 +66,11 @@
>   		ranges = <0x0 0x0 0x0 0xc0000000>;
>   		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
>
> +		pllctrl: pll_controller {

   I think it's better to follow the pattern established by "reset-controller" 
and use hyphen ISO dash in the node name. This is also a common practice to 
use hyphens in the device trees overall.

> +			compatible = "ti,keystone-pllctrl", "syscon";
> +			reg = <0x2310000 0x200>;
> +		};
> +
>   		rstctrl: reset-controller {
>   			compatible = "ti,keystone-reset";
>   			reg = <0x023100e8 4>;	/* pll reset control reg */
>

WBR, Sergei

