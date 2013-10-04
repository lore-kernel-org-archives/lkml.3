Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3JDKXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:23:00 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53812 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3JDKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:22:58 -0400
Message-ID: <524E96E8.5030103@gmail.com>
Date: Fri, 04 Oct 2013 12:22:32 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jean-Francois Moine <moinejf@free.fr>, Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: Dove: fix bad properties of the si5351 clkout2 used
 by Cubox audio
References: <20131004122105.60f605cd@armhf>
In-Reply-To: <20131004122105.60f605cd@armhf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 12:21 PM, Jean-Francois Moine wrote:
> As defined in the DT, clkout2 is not allowed to change the pll inside
> si5351.
>
> This patch inverts the properties of the clkout{1,2} so that clkout2
> may be defined as the external clock of the audio device in the Cubox.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   arch/arm/boot/dts/dove-cubox.dts | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index 022646e..5d1ece1 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -101,16 +101,16 @@
>
>   		clkout1 {
>   			reg = <1>;
> -			silabs,drive-strength = <8>;
>   			silabs,multisynth-source = <1>;
>   			silabs,clock-source = <0>;
> -			silabs,pll-master;
>   		};

Jean-Francois,

thanks for the patch! If we have no use for clkout1 at all on CuBox,
we can also remove the above completely.

For this or an updated patch which removes clkout1 completely:

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

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

