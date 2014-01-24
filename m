Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaAXLJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:09:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42773 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbaAXLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:09:47 -0500
Date: Fri, 24 Jan 2014 11:09:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 8/8] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
Message-ID: <20140124110910.GC814@e106331-lin.cambridge.arm.com>
References: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com>
 <1390361452-3124-9-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390361452-3124-9-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 03:30:52AM +0000, Marc Carino wrote:
> Add a sample DTS which will allow bootup of a board populated
> with the BCM7445 chip.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/boot/dts/bcm7445.dts |  111 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 111 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/bcm7445.dts
> 
> diff --git a/arch/arm/boot/dts/bcm7445.dts b/arch/arm/boot/dts/bcm7445.dts
> new file mode 100644
> index 0000000..ffa3305
> --- /dev/null
> +++ b/arch/arm/boot/dts/bcm7445.dts
> @@ -0,0 +1,111 @@
> +/dts-v1/;
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +	model = "Broadcom STB (bcm7445)";
> +	compatible = "brcm,bcm7445", "brcm,brcmstb";
> +	interrupt-parent = <&gic>;
> +
> +	chosen {};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x00 0x00000000 0x00 0x40000000>,
> +		      <0x00 0x40000000 0x00 0x40000000>,
> +		      <0x00 0x80000000 0x00 0x40000000>;
> +	};

As I commented on v3 [1], these are contiguous and can be described with
a single entry:

memory {
	device_type = "memory";
	reg = <0x0 0x00000000 0x0 0xc0000000>;
};

Is there any reason to have three entries?

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/225899.html
