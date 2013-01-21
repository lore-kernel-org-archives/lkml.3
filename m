Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3AUVCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:02:03 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47446 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3AUVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:02:00 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <zonque@gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: AM33XX: Add GPMC node
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
	<1358491295-4022-3-git-send-email-avinashphilip@ti.com>
Date: Mon, 21 Jan 2013 22:01:53 +0100
In-Reply-To: <1358491295-4022-3-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Fri, 18 Jan 2013 12:11:34 +0530")
Message-ID: <8738xu9rni.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:

 Philip> From: "Philip, Avinash" <avinashphilip@ti.com>
 Philip> Add GPMC data node to AM33XX device tree file.

 Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
 Philip> ---
 Philip>  arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
 Philip>  1 file changed, 12 insertions(+)

 Philip> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
 Philip> index eaef5e7..f4209d8 100644
 Philip> --- a/arch/arm/boot/dts/am33xx.dtsi
 Philip> +++ b/arch/arm/boot/dts/am33xx.dtsi
 Philip> @@ -393,5 +393,17 @@
 Philip>  			ti,hwmods = "elm";
 Philip>  			status = "disabled";
 Philip>  		};
 Philip> +
 Philip> +		gpmc: gpmc@50000000 {
 Philip> +			compatible = "ti,am3352-gpmc";
 Philip> +			ti,hwmods = "gpmc";
 Philip> +			reg = <0x50000000 0x2000>;
 Philip> +			interrupts = <100>;
 Philip> +			num-cs = <8>;

Next to Jan's comment about am335x having 7 cs signals, I just realized
the difference in compatible string between the gpmc and elm. The gpmc
refers to a real device (which is afaik how it should be done), but the
elm compatible is simply ti,am33xx-elm.

Presumably it should have been ti,am3352-elm in the binding instead?

Other than that it looks fine.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
