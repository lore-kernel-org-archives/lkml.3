Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3HZNVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:21:20 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36765 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3HZNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:21:18 -0400
Message-ID: <521B5648.3020608@cogentembedded.com>
Date: Mon, 26 Aug 2013 17:21:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: at91/dt: define phy available on sama5d3
 mother board
References: <1377520431-21807-1-git-send-email-b.brezillon@overkiz.com> <1377520540-21884-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377520540-21884-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-08-2013 16:35, Boris BREZILLON wrote:

> This patch describe the phy used on atmel sama5d3 mother board:
>   - phy address
>   - phy interrupt pin

> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/boot/dts/sama5d3xmb.dtsi |    8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 8a9e05d..e9521d5 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -81,6 +81,14 @@
>
>   			macb1: ethernet@f802c000 {
>   				phy-mode = "rmii";
> +
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				phy0: ethernet-phy@0 {

    Address part of the node name doesn't match the "reg" property.

> +					interrupt-parent = <&pioE>;
> +					interrupts = <30 IRQ_TYPE_EDGE_FALLING>;
> +					reg = <1>;
> +				};

WBR, Sergei

