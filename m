Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaCQOHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:07:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42892 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756244AbaCQOHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:07:00 -0400
Date: Mon, 17 Mar 2014 14:06:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Girish K S <ks.giri@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jassisinghbrar@gmail.com" <jassisinghbrar@gmail.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Message-ID: <20140317140625.GJ8070@e106331-lin.cambridge.arm.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
 <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
Thread-Topic: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 12:03:59PM +0000, Girish K S wrote:
> This patch adds the dt node for the mailbox IP
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> 
> Change-Id: I35e45e9a62592887a84a909aee54f259a2f731fa
> ---
>  .../bindings/mailbox/samsung-mailbox.txt           |   24 +++++++
>  arch/arm64/boot/dts/samsung-gh7.dtsi               |   66 ++++++++++++++++++++
>  arch/arm64/boot/dts/samsung-ssdk-gh7.dts           |    3 +
>  3 files changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
> 
> diff --git a/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
> new file mode 100644
> index 0000000..1908d71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
> @@ -0,0 +1,24 @@
> +
> +Samsung Mailbox Driver
> +
> +Required properties:
> +- compatible:		Should be one of the following,
> +			    "samsung,gh7-mailbox" for
> +				Samsung GH7 SoC series
> +			    "samsung,exynos-mailbox" for
> +				exynosx SoC series
> +- reg:			Contains the mailbox register address range (base address
> +			and length)
> +- interrupts: 		Contains the interrupt information for the mailbox
> +			device.

How many interrupts?

What are they for?

> +- samsung,mbox-names:	Array of the names of the mailboxes

Juding by the code there is one name per reg entry, but the description
above implies a single entry (as all the dt fragments have).

What values are expected? What is the consumer of these values? What are
they used for?

> +
> +Example:
> +
> +/* Samsung GH7 SoC */
> +mailbox@100a0000 {
> +	compatible = "samsung,gh7-mailbox";
> +	reg = <0x0 0x100a0000 0x0 0x1000>;
> +	interrupts = <0 310 0>;
> +	samsung,mbox-names = "a7q-scp";
> +};
> diff --git a/arch/arm64/boot/dts/samsung-gh7.dtsi b/arch/arm64/boot/dts/samsung-gh7.dtsi
> index c3610bd..be4cce9 100644
> --- a/arch/arm64/boot/dts/samsung-gh7.dtsi
> +++ b/arch/arm64/boot/dts/samsung-gh7.dtsi
> @@ -107,5 +107,71 @@
>  			interrupts = <0 420 0>;
>  			arm,primecell-periphid = <0x341011>; /* HACK */

This looks odd.

What tree is this against?

Cheers,
Mark.
