Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaJJOB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:01:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614AbaJJOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:01:52 -0400
Date: Fri, 10 Oct 2014 16:01:48 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andreas Henriksson <andreas.henriksson@endian.se>
Subject: Re: [PATCH] ARM: at91/dt: sam9263: fix PLLB frequencies
Message-ID: <20141010160148.57290e20@bbrezillon>
In-Reply-To: <1412949021-15150-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1412949021-15150-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014 15:50:21 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> From: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> PLLB input and output ranges were wrongly copied from at91sam9261 as the
> datasheet didn't mention explicitly PLLB. Correct their values.
> 
> This fixes USB.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Thanks for sending this patch.

Just adding Andreas in Cc and adding his Reported and Tested-by.

Reported-by: Andreas Henriksson <andreas.henriksson@endian.se>
Tested-by: Andreas Henriksson <andreas.henriksson@endian.se>

> ---
>  arch/arm/boot/dts/at91sam9263.dtsi | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
> index d68b3c4862bc..51416c7d0625 100644
> --- a/arch/arm/boot/dts/at91sam9263.dtsi
> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> @@ -122,9 +122,10 @@
>  					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
>  					clocks = <&main>;
>  					reg = <1>;
> -					atmel,clk-input-range = <1000000 5000000>;
> +					atmel,clk-input-range = <1000000 32000000>;
>  					#atmel,pll-clk-output-range-cells = <4>;
> -					atmel,pll-clk-output-ranges = <70000000 130000000 1 1>;
> +					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
> +								<190000000 240000000 2 1>;
>  				};
>  
>  				mck: masterck {



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
