Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbbAVWLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:11:10 -0500
Received: from smtp1.ore.mailhop.org ([54.68.34.165]:51915 "EHLO
	smtp1.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAVWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:11:08 -0500
X-Greylist: delayed 1782 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 17:11:08 EST
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX18HGi8A14WNwCZaomd94vwS
Date: Thu, 22 Jan 2015 13:40:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, neilb@suse.de,
        NeilBrown <neil@brown.name>
Subject: Re: [PATCH 12/13] ARM: dts: omap3-gta04: uart4 is not connected, so
 mark it "disabled"
Message-ID: <20150122214052.GY7718@atomide.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
 <1421959099-28319-13-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421959099-28319-13-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [150122 12:42]:
> From: NeilBrown <neil@brown.name>
> 
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
> index 228e79b..8d2b0a1 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> @@ -357,6 +357,10 @@
>  	pinctrl-0 = <&uart3_pins>;
>  };
>  
> +&uart4 {
> +	status = "disabled";
> +};
> +

This you probably want to avoid from PM point of view. Depending on
bootloader state of uart4, Linux may or may not be able to hit any
deeper power states.

Marking something with status = "disabled" in dts causes the device
entry not even to be created. That means hwmod won't be able to reset
and idle this device during boot.

The uart4 device is there for sure even if not muxed and in incomplete
state. You may want to also check other places where you're using
status = "disabled" for the same reasons.

Regards,

Tony
