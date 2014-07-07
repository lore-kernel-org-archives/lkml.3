Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaGGS2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:28:48 -0400
Received: from 17.mo5.mail-out.ovh.net ([46.105.56.132]:41716 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbaGGS2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:28:46 -0400
Date: Mon, 7 Jul 2014 20:32:36 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] ARM: at91/dt: sama5d3: define mpddr clock and ramc
 clocks
Message-ID: <20140707183236.GF9558@ns203013.ovh.net>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404746355-19988-4-git-send-email-alexandre.belloni@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16671199922356857747
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:19 Mon 07 Jul     , Alexandre Belloni wrote:
> 
> Define the available clock for mprddr and take both mpddr_clk and ddrck in the
> ram controller driver.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index e0b15a6e8897..3bd8db9e069b 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -402,8 +402,10 @@
>  			};
>  
>  			ramc0: ramc@ffffea00 {
> -				compatible = "atmel,at91sam9g45-ddramc";
> +				compatible = "atmel,sama5d3-mpddramc", "atmel,at91sam9g45-ddramc";
the sama5 ddr controler is not back compitble with 9g45 one the compatible is
wrong
>  				reg = <0xffffea00 0x200>;
> +				clocks = <&ddrck>, <&mpddr_clk>;
> +				clock-names = "ddrck", "mpddr";
>  			};
>  
>  			dbgu: serial@ffffee00 {
> @@ -1170,6 +1172,11 @@
>  						#clock-cells = <0>;
>  						reg = <48>;
>  					};
> +
> +					mpddr_clk: mpddr_clk {
> +						#clock-cells = <0>;
> +						reg = <49>;
> +					};
>  				};
>  			};
>  
> -- 
> 1.9.1
> 
