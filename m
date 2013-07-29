Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3G2Mli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:41:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43858 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3G2Mlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:35 -0400
Message-ID: <51F6630D.5010603@arm.com>
Date: Mon, 29 Jul 2013 13:41:49 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep.KarkadaNagesha@arm.com
Subject: Re: [PATCH 1/4] ARM: dove: add cpu device tree node
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375100946-28521-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1375100946-28521-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-OriginalArrivalTime: 29 Jul 2013 12:41:32.0494 (UTC) FILETIME=[F45B06E0:01CE8C58]
X-MC-Unique: 113072913413301001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/13 13:29, Sebastian Hesselbarth wrote:
> This adds a node for the Marvell Sheeva PJ4A CPU found on Dove SoCs.
> While at it, also move the l2-cache node out of internal registers and
> consistently name different nodes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove.dtsi |   52 ++++++++++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index 8d5be1e8..09d9710 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -10,6 +10,23 @@
>  		gpio2 = &gpio2;
>  	};
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu0: cpu@0 {
> +			compatible = "marvell,pj4a", "marvell,sheeva-v7";
> +			device_type = "cpu";
> +			next-level-cache = <&l2>;
> +			reg = <0>;
> +		};
> +	};
> +
> +	l2: l2-cache {
> +		compatible = "marvell,tauros2-cache";
> +		marvell,tauros2-cache-features = <0>;
> +	};
Hi Sebastian,

This is not entirely related to the patch but thought of checking with
you. I was trying to get info on L2 cache controller on Marvell SoCs,
mainly structure or way/set size. Is that something we can get
dynamically ? Some specification I referred said its integrated and some
said its separate(not unified). Basically I need information around
various L2 cache implementations(Tauros2/Feroceon) from Marvell.

Any pointers or contacts to get this information will be helpful.

Regards,
Sudeep


