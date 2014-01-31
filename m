Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaAaOpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:45:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaAaOpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:45:52 -0500
Message-ID: <52EBB6F5.8080701@ti.com>
Date: Fri, 31 Jan 2014 09:45:09 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <robh+dt@kernel.org>,
        <galak@codeaurora.org>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: keystone: dts: drop "msmcsram" clock node
References: <1391105400-31602-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1391105400-31602-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014 01:10 PM, Ivan Khoronzhuk wrote:
> At late init all unused clocks are disabled. So clocks that were not
> get before will be gated. In Keysone 2 SoC we have at least one
> necessary clock that is not used by any driver - "msmcsram". This
> clock is necessary, because it supplies the Multicore Shared Memory
> Controller (MSMC). MSMC is the coherency interconnect and all the
> coherent masters are connected to it including devices which are not
> under Linux OS control. MSMC clock should not be touched even in low
> power states.
> 
> So drop the clock node, otherwise 'clk_ignore_unused' parameter will
> disable the clock leading to system stall.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> Based on
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> keystone/master
> 
> v1..v2:
> - dropped "msmcsram" clock node, instead disabling
> - updated comment message
> 
Thanks for the update. Would be good to get blessing from DT folks.
I want to send this one during the rc's since its a bug fix.

>  arch/arm/boot/dts/keystone-clocks.dtsi | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/keystone-clocks.dtsi b/arch/arm/boot/dts/keystone-clocks.dtsi
> index 2363593..98ad488 100644
> --- a/arch/arm/boot/dts/keystone-clocks.dtsi
> +++ b/arch/arm/boot/dts/keystone-clocks.dtsi
> @@ -327,16 +327,6 @@ clocks {
>  		domain-id = <6>;
>  	};
>  
> -	clkmsmcsram: clkmsmcsram {
> -		#clock-cells = <0>;
> -		compatible = "ti,keystone,psc-clock";
> -		clocks = <&chipclk1>;
> -		clock-output-names = "msmcsram";
> -		reg = <0x02350038 0xb00>, <0x0235001c 0x400>;
> -		reg-names = "control", "domain";
> -		domain-id = <7>;
> -	};
> -
>  	clkgem0: clkgem0 {
>  		#clock-cells = <0>;
>  		compatible = "ti,keystone,psc-clock";
> 

