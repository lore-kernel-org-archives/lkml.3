Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3LBLpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:45:04 -0500
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:58658 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257Ab3LBLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:45:00 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 06:45:00 EST
Message-ID: <529C70C7.9050707@overkiz.com>
Date: Mon, 02 Dec 2013 12:36:39 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, jiri.prchal@aksignal.cz
Subject: Re: [PATCH] ARM: at91: add usart3 alias to dtsi
References: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8127308477948590188
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

Le 02/12/2013 11:13, Nicolas Ferre a écrit :
> Alias was missing for SoC of the at91sam9x5 familly that embed USART3.
> Preripheral node and pinctrl declarations are already in the
> at91sam9x5_usart3.dtsi file.
>
> Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/boot/dts/at91sam9g25.dtsi | 4 ++++
>   arch/arm/boot/dts/at91sam9x25.dtsi | 4 ++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
> index 17b879990914..d4650b4e9ebb 100644
> --- a/arch/arm/boot/dts/at91sam9g25.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g25.dtsi
> @@ -14,6 +14,10 @@
>   	model = "Atmel AT91SAM9G25 SoC";
>   	compatible = "atmel,at91sam9g25", "atmel,at91sam9x5";
>   
> +	aliases {
> +		serial4 = &usart3;
> +	};
> +

Shouldn't this go into at91sam9x5_usart3.dtsi ?
This way you would have the same alias for all the SoCs supporting usart3.

Best Regards,

Boris

>   	ahb {
>   		apb {
>   			pinctrl@fffff400 {
> diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
> index c2554219f7a4..aceee86f60eb 100644
> --- a/arch/arm/boot/dts/at91sam9x25.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x25.dtsi
> @@ -15,6 +15,10 @@
>   	model = "Atmel AT91SAM9X25 SoC";
>   	compatible = "atmel,at91sam9x25", "atmel,at91sam9x5";
>   
> +	aliases {
> +		serial4 = &usart3;
> +	};
> +
>   	ahb {
>   		apb {
>   			pinctrl@fffff400 {

