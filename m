Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3H1TtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:49:18 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59414 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3H1TtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:49:14 -0400
Message-ID: <521E5438.90109@cogentembedded.com>
Date: Wed, 28 Aug 2013 23:49:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf>
In-Reply-To: <20130828113459.48ecbb34@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/28/2013 01:34 PM, Jean-Francois Moine wrote:

> This patch adds the nodes to instantiate the audio devices of the Dove
> boards.

> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   arch/arm/boot/dts/dove.dtsi                  | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)

> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index 499abad..78227e2 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -573,6 +573,24 @@
>   					phy-handle = <&ethphy>;
>   				};
>   			};
> +
> +			i2s0: audio-controller@b0000 {

     According to ePAPR [1] the node should be called "sound", not 
"audio-controller".

> +				compatible = "marvell,mvebu-audio";
> +				reg = <0xb0000 0x2210>;
> +				interrupts = <19>, <20>;
> +				clocks = <&gate_clk 12>;
> +				clock-names = "internal";
> +				status = "disabled";
> +			};
> +
> +			i2s1: audio-controller@b4000 {

    Same comment.

> +				compatible = "marvell,mvebu-audio";
> +				reg = <0xb4000 0x2210>;
> +				interrupts = <21>, <22>;
> +				clocks = <&gate_clk 13>;
> +				clock-names = "internal";
> +				status = "disabled";
> +			};

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei


