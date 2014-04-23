Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaDWIei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:34:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45930 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbaDWIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:34:33 -0400
Date: Wed, 23 Apr 2014 09:34:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] dt/bindings: Add the DT binding documentation
 for endianness
Message-ID: <20140423083412.GA30036@e106331-lin.cambridge.arm.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
 <1398235595-13370-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398235595-13370-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:46:33AM +0100, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/endianness/endianness.txt  | 55 ++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt
> 
> diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt b/Documentation/devicetree/bindings/endianness/endianness.txt
> new file mode 100644
> index 0000000..64f1d5e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/endianness/endianness.txt
> @@ -0,0 +1,55 @@
> +Device-Tree binding for device endianness
> +
> +The endianness mode of CPU & Device scenarios:
> +  Index    CPU      Device
> +  ------------------------
> +  1        LE         LE
> +  2        LE         BE
> +  3        BE         BE
> +  4        BE         LE
> +
> +For one device driver, which will run in different scenarios above
> +on different SoCs using the devicetree, we need one way to simplify
> +this.
> +
> +Required properties:
> +- [prefix]-endian: this is one string property and must be one
> +  of 'be', 'le' and 'native' if it is present.

What exactly is the prefix?

This file name and file heading implies this is a common endianness
binding, which it is not. There are many existing bindings that have
mechanisms for describing the endianness of components, and they have
settled on a different pattern.

We already have many bindings with {big,little}-endian{,-*} boolean
properties. It would be better to take that common case and document
that as the standard way of doing things rather than inventing a
completely different mechanism.

> +The endianness mode:
> +  'le' : device is in little endian mode,
> +  'be' : device is in big endian mode,
> +  'native' : device is in the same endian mode with the CPU.

What exactly do you mean by native? A device which always matches the
endianness of the CPU even if it changes? How common is that?

> +
> +Examples:
> +Scenario 1 : CPU in LE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      [prefix]-endian = 'native';
> +};

If the device is LE, then surely we should describe the device as LE.
The kernel knows what endianness it is, might choose to change the CPU
endianness, but regardless can do the right thing. Telling it a device
is native is useless unless the device changes endianness with the CPU.

> +
> +Scenario 2 : CPU in LE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      [prefix]-endian = 'be';
> +};
> +
> +Scenario 3 : CPU in BE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      [prefix]-endian = 'native';
> +};

Likewise.

Thanks,
Mark.
