Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaJHJuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:50:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39089 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbaJHJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:50:44 -0400
Date: Wed, 8 Oct 2014 10:50:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "patches@apm.com" <patches@apm.com>,
        "jassisingbrar@gmail.com" <jassisingbrar@gmail.com>,
        "=devicetree@vger.kernel.org" <=devicetree@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] Documentation: mailbox: Add APM X-Gene SLIMpro
 mailbox dts documentation
Message-ID: <20141008095012.GH27216@leverpostej>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
 <1412726809-7525-3-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412726809-7525-3-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:06:45AM +0100, Feng Kan wrote:
> This adds the APM X-Gene SLIMpro mailbox device tree node documentation.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  .../bindings/mailbox/xgene-slimpro-mailbox.txt     | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
> 
> diff --git a/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt b/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
> new file mode 100644
> index 0000000..d0b74fb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
> @@ -0,0 +1,41 @@
> +The APM X-Gene SLIMpro mailbox driver is used to communicate messages between
> +the ARM64 processors and the Cortex M3 (dubbed SLIMpro). It uses a simple
> +interrupt based door bell mechanism and can exchange simple messages using the
> +internal registers.

The above should be a description of the hardware organisation, not the
Linux driver. Removing the word "driver" in the above should be
sufficient.

> +
> +There are total of 8 interrupts in this mailbox. Each used for an individual
> +door bell (or mailbox channel).

This should be described in the interrupts property.

> +
> +Required properties:
> +- compatible:	Should be as "apm, xgene-slimpro-mbox".

That space shouldn't be there.

> +
> +- reg:		Contain the mailbox register address range.
> +
> +- interrupts:	Contain interrupt information for the mailbox device.

Please describe the specifics of this proeprty. This description is too
general to be of any use. Specific how many interrupts you expect, the
order thereof, etc. If there's not a well-defined ordering, or if you
believe interrupts will be omitted, use interrupt-names, and define
interrutps in terms of it.

> +
> +- #mbox-cells:	Specify the number of parameters used by the mailbox client.
> +		Currently only one to specify the mailbox channel number.

This should be a description of the specific values expected by this
binding rather than the general meaning of this property. How many mbox
cells do you expect (1, it seems?), and what does each encode(the index
of the mailbox?)?

Thanks,
Mark.

> +
> +Example:
> +
> +Mailbox Node:
> +		slimpro-mbox: slimpro-mbox@10540000 {
> +			compatible = "apm,xgene-slimpro-mbox";
> +			reg = <0x0 0x10540000 0x0 0xa000>;
> +			#mbox-cells = <1>;
> +			interrupts =  	<0x0 0x0 0x4>,
> +					<0x0 0x1 0x4>,
> +					<0x0 0x2 0x4>,
> +					<0x0 0x3 0x4>,
> +					<0x0 0x4 0x4>,
> +					<0x0 0x5 0x4>,
> +					<0x0 0x6 0x4>,
> +					<0x0 0x7 0x4>;
> +		};
> +
> +Client Node:
> +		i2c-slimpro {
> +			compatible = "apm,xgene-slimpro-i2c";
> +			mbox = <&slimpro-mbox 0>;
> +			mbox-names = "i2c-slimpro";
> +		};
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
