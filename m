Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3H1KNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:13:48 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:56575 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3H1KNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:13:47 -0400
Message-ID: <521DCD33.2070008@gmail.com>
Date: Wed, 28 Aug 2013 12:13:07 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf>
In-Reply-To: <20130828113459.48ecbb34@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 11:34 AM, Jean-Francois Moine wrote:
> This patch adds the nodes to instantiate the audio devices of the Dove
> boards.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   arch/arm/boot/dts/dove.dtsi                  | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
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
> +				compatible = "marvell,mvebu-audio";

[added Gregory to Cc]

Jean-Francois,

as Mark Brown already took the bindings patch for above generic
compatible, how are we going to discriminate different
implementations/features of Dove, Kirkwood, and Armada 370?

Sebastian

> +				reg = <0xb0000 0x2210>;
> +				interrupts = <19>, <20>;
> +				clocks = <&gate_clk 12>;
> +				clock-names = "internal";
> +				status = "disabled";
> +			};
> +
> +			i2s1: audio-controller@b4000 {
> +				compatible = "marvell,mvebu-audio";
> +				reg = <0xb4000 0x2210>;
> +				interrupts = <21>, <22>;
> +				clocks = <&gate_clk 13>;
> +				clock-names = "internal";
> +				status = "disabled";
> +			};
>   		};
>   	};
>   };
>
>

