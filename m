Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaICV1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:27:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49009 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaICV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:27:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+2dn3rNUFL01Fts3xSdz4
Date: Wed, 3 Sep 2014 14:27:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap4-panda: Fix model and SoC family details
Message-ID: <20140903212732.GI11766@atomide.com>
References: <1409258703-21188-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409258703-21188-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140828 13:45]:
> Currently we claim that omap4-panda and omap4-panda-es are essentially
> the same, but they are not since PandaBoard-ES uses OMAP4460 and
> PandaBoard uses OMAP4430.
> 
> So, split the common definition and make the model name available.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Based on v3.17-rc2
> 
> Testing logs: (boot test):
> Before Patch(v3.17-rc2)
> 1: pandaboard-es:  Boot PASS: http://slexy.org/raw/s209HfpVTs
> 2: pandaboard-vanilla:  Boot PASS: http://slexy.org/raw/s21YNmOhQL
> 
> After Patch
> 1: pandaboard-es:  Boot PASS: http://slexy.org/raw/s20FH76BTn
> 2: pandaboard-vanilla:  Boot PASS: http://slexy.org/raw/s2vFLcfkBu
 
Thanks applying into omap-for-v3.18/fixes-not-urgent.

> Note: 'ti,omap4-panda-es' is not documented in bindings, not entirely
> sure if we should be doing the same for every board compatibility.

That should probably be done on regular basis with some script
if we want to keep the documentation updated.

Regards,

Tony
 
>  arch/arm/boot/dts/omap4-panda-common.dtsi |    3 ---
>  arch/arm/boot/dts/omap4-panda-es.dts      |    5 +++++
>  arch/arm/boot/dts/omap4-panda.dts         |    5 +++++
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index 8cfa3c8..1505135 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -8,9 +8,6 @@
>  #include "elpida_ecb240abacn.dtsi"
>  
>  / {
> -	model = "TI OMAP4 PandaBoard";
> -	compatible = "ti,omap4-panda", "ti,omap4430", "ti,omap4";
> -
>  	memory {
>  		device_type = "memory";
>  		reg = <0x80000000 0x40000000>; /* 1 GB */
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
> index 816d1c9..2f1dabc 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -10,6 +10,11 @@
>  #include "omap4460.dtsi"
>  #include "omap4-panda-common.dtsi"
>  
> +/ {
> +	model = "TI OMAP4 PandaBoard-ES";
> +	compatible = "ti,omap4-panda-es", "ti,omap4-panda", "ti,omap4460", "ti,omap4430", "ti,omap4";
> +};
> +
>  /* Audio routing is differnet between PandaBoard4430 and PandaBoardES */
>  &sound {
>  	ti,model = "PandaBoardES";
> diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
> index 6189a8b..a0e28b2 100644
> --- a/arch/arm/boot/dts/omap4-panda.dts
> +++ b/arch/arm/boot/dts/omap4-panda.dts
> @@ -9,3 +9,8 @@
>  
>  #include "omap443x.dtsi"
>  #include "omap4-panda-common.dtsi"
> +
> +/ {
> +	model = "TI OMAP4 PandaBoard";
> +	compatible = "ti,omap4-panda", "ti,omap4430", "ti,omap4";
> +};
> -- 
> 1.7.9.5
> 
