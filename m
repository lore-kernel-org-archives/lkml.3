Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3JHSUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:20:03 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:35933 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3JHST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:19:59 -0400
Message-ID: <52544CC1.6010502@gmail.com>
Date: Tue, 08 Oct 2013 20:19:45 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jean-Francois Moine <moinejf@free.fr>, Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: Dove: fix bad properties of the si5351 clkout2
 used by Cubox audio
References: <20131008202027.6d9f0bd2@armhf>
In-Reply-To: <20131008202027.6d9f0bd2@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 08:20 PM, Jean-Francois Moine wrote:
> As defined in the DT, clkout2 is not allowed to change the pll inside
> si5351.
>
> This patch extends the properties of clkout2 so that it works as the
> external clock of the audio device in the Cubox.
>
> Also, as the second si5351 clock is not used in the Cubox, its
> definition is removed.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Already gave my

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

which you should add to help us keep track of them next time.

> ---
> v2:
> - remove clkout1 which is not used in the Cubox (Sebastian Hesselbarth)
> ---
>   arch/arm/boot/dts/dove-cubox.dts | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index bb38a24..3dd8844 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -99,18 +99,12 @@
>   			silabs,pll-master;
>   		};
>
> -		clkout1 {
> -			reg = <1>;
> -			silabs,drive-strength = <8>;
> -			silabs,multisynth-source = <1>;
> -			silabs,clock-source = <0>;
> -			silabs,pll-master;
> -		};
> -
>   		clkout2 {
>   			reg = <2>;
> +			silabs,drive-strength = <8>;
>   			silabs,multisynth-source = <1>;
>   			silabs,clock-source = <0>;
> +			silabs,pll-master;
>   		};
>   	};
>   };
>
>

