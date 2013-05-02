Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913Ab3EBTw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:52:59 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3EBTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:52:58 -0400
Date: Thu, 2 May 2013 16:53:16 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: kirkwood: add button for OpenBlock A6
Message-ID: <20130502195315.GA4107@localhost>
References: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Thu, May 02, 2013 at 09:43:22PM +0200, Gregory CLEMENT wrote:
> The OpenBlocks A6 board has one software-controlled button on the
> front side, labeled "INIT", so we add minimal support for this button
> in the kernel.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/boot/dts/kirkwood-openblocks_a6.dts |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> index d27f724..627d8d0 100644
> --- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> +++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
> @@ -209,4 +209,17 @@
>  			gpios = <&gpio1 11 1>;
>  		};
>          };
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +			button@1 {
> +			label = "Init Button";
> +			linux,code = <116>;
> +			gpios = <&gpio1 6 0>;
> +		};
> +	};
> +
>  };

Shouldn't you add a proper pinctrl entry for this as well?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
