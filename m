Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaLQOzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:55:37 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:44468 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaLQOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:55:35 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 17 Dec 2014 09:55:33 -0500
To: Tero Kristo <t-kristo@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141217145533.GS24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
 <20141216145856.GA23358@kahuna>
 <54918357.8060801@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54918357.8060801@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 03:21:27PM +0200, Tero Kristo wrote:
> Yea I think the 32k clock node should be fixed based on this.
> Something like this:
> 
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -100,8 +100,10 @@
> 
>         sys_32k_ck: sys_32k_ck {
>                 #clock-cells = <0>;
> -               compatible = "fixed-clock";
> -               clock-frequency = <32768>;
> +               compatible = "fixed-factor-clock";
> +               clocks = <&sys_clkin1>;
> +               clock-mult = <1>;
> +               clock-div = <610>;
>         };
> 
>         virt_12000000_ck: virt_12000000_ck {
> 
> 
> It might be better then just query the actual clock rate from the
> timer code.

But it is only SYSCLK1 / 610 if the DRA7_CTRL_CORE_BOOTSTRAP register
says it is.  Otherwise is is in fact 32768Hz.  I certainly would expect
that if another revision of the chip is made (and even for the single
core AM571x chips when they are done) will have this fixed and will work
with the external 32.768KHz crystal, if it is present.

So how does one make the dtb reflect what the state of the CPU actually
is?

The errata even says that if SYSCLK1 is 26MHz (not a supported option
in the manual), then the 32.768KHz crystal does work and the counter
frequency will in fact be 6.144MHz like it should be.

So just changing the dtb is not an option.

-- 
Len Sorensen
