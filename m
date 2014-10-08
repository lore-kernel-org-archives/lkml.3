Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaJHKMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:12:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39424 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbaJHKMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:12:17 -0400
Date: Wed, 8 Oct 2014 11:11:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "patches@apm.com" <patches@apm.com>,
        "jassisingbrar@gmail.com" <jassisingbrar@gmail.com>,
        "=devicetree@vger.kernel.org" <=devicetree@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hieu Le <hnle@apm.com>
Subject: Re: [PATCH 5/6] Documentation: i2c: Add APM X-Gene platform SLIMpro
 I2C driver documentation
Message-ID: <20141008101144.GJ27216@leverpostej>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
 <1412726809-7525-6-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412726809-7525-6-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:06:48AM +0100, Feng Kan wrote:
> Add APM X-Gene platform SLIMpro I2C driver documentation.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> Signed-off-by: Hieu Le <hnle@apm.com>
> ---
>  .../devicetree/bindings/i2c/i2c-xgene-slimpro.txt    | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt b/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> new file mode 100644
> index 0000000..1a79d53
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
> @@ -0,0 +1,20 @@
> +APM X-Gene SLIMpro Mailbox I2C Driver
> +
> +This is a I2C driver that access the I2C bus through the mailbox mechanism.
> +There is documentation of the mailbox driver in the
> +Documentation/devicetree/binding/mailbox/xgene-slimpro-mbox.txt

This should not describe the driver. It should describe the hardware (an
I2C controller accessed over the "slimpro" mailbox).

> +
> +Required properties :
> +
> + - compatible : should be "apm,xgene-slimpro-i2c"
> + - mbox : ptr to the mailbox dts node, use the name of the mailbox as the
> +	  first parameter. The second parameter is the channel number.

This is a phandle + specificer pair, the "name" you mention is a label
reference (which generates a phandle).

> +	  The APM X-Gene SLIMpro mailbox has 8 channels.

Does it really make sense to model the slimpro in this way if all the
clients are going to rely on the particulars of this mailbox?

Either this is somewhat generic and the mailbox details are
unimportant, or it is not and the entire device would be better modelled
as an MFD.

> + - mbox-names : the name of the mailbox channel.

For any *-names property, you must define the _exact_ names you expect,
or you shouldn't use the property. The entire point of the property is
to disambiguate entries, and this is _more_ ambiguous than without the
property.

Mark.

> +
> +Example :
> +	i2cslimpro {
> +		compatible = "apm,xgene-slimpro-i2c";
> +		mbox = <&mailbox 0>;
> +		mbox-names = "i2c-slimpro";
> +	};
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
