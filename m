Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3H1KPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:15:05 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40352 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3H1KPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:15:02 -0400
Message-ID: <521DCD80.9010105@gmail.com>
Date: Wed, 28 Aug 2013 12:14:24 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
References: <20130828113521.35c53365@armhf>
In-Reply-To: <20130828113521.35c53365@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 11:35 AM, Jean-Francois Moine wrote:
> This patch activates the audio device of the Cubox and sets the i2s
> and S/PDIF pins.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   arch/arm/boot/dts/dove-cubox.dts                  | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index 4af59b6..003d95b 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -132,3 +132,16 @@
>   		reg = <0>;
>   	};
>   };
> +
> +&pinctrl {
> +	pmx_audio1_i2s1_spdifo: pmx-audio1-i2s1-spdifo {
> +		marvell,pins = "mpp_audio1";
> +		marvell,function = "i2s1/spdifo";
> +	};
> +};
> +
> +&i2s1 {
> +	status = "okay";
> +	pinctrl-0 = <&pmx_audio1_i2s1_spdifo>;
> +	pinctrl-names = "default";
> +};

Please also add the external clock connected from si5351.

Sebastian
