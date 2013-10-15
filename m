Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3JOH2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:28:36 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57823 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3JOH2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:28:34 -0400
Message-ID: <525CEE9E.9020507@baylibre.com>
Date: Tue, 15 Oct 2013 09:28:30 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Rajendra Nayak <rnayak@ti.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap4-panda-es: Do not reset gpio1
References: <1381313521-10422-1-git-send-email-rnayak@ti.com> <1381423481-5920-1-git-send-email-nm@ti.com>
In-Reply-To: <1381423481-5920-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On 10/10/2013 18:44, Nishanth Menon wrote:
> Do not reset GPIO1 at boot-up because GPIO 7 in GPIO1 block is used on
> OMAP4460 PandaBoard-ES to select voltage register in TPS62361 which
> supplies VDD_MPU.
>
> Without this, OMAP4460 PandaBoard-ES boards fail to boot-up because
> MPU voltage switches over to VSET0 voltage value (boot voltage) which
> is not sufficient to operate the device at OPP100.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> As explained here: http://marc.info/?l=u-boot&m=133066647800872&w=2
>
> GPIO1 reset causes PandaBoard-ES to stop functioning.
> This depends on Patch series from Rajendra:
> http://marc.info/?l=linux-doc&m=138131355520116&w=2
> Applies on Benoit's for_13/dts branch:
> https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts

I've just applied it after Rajendra's series.

Thanks,
Benoit


>
> Tested on PandaBoard-ES without the u-boot uenv hack
>
>   arch/arm/boot/dts/omap4-panda-es.dts |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
> index 56c4354..816d1c9 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -62,3 +62,7 @@
>   		gpios = <&gpio1 8 GPIO_ACTIVE_HIGH>;
>   	};
>   };
> +
> +&gpio1 {
> +	 ti,no-reset-on-init;
> +};
>


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
