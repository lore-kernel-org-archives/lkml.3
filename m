Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaDWIka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:40:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46085 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbaDWIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:40:24 -0400
Date: Wed, 23 Apr 2014 09:40:09 +0100
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
Subject: Re: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Message-ID: <20140423084009.GB30036@e106331-lin.cambridge.arm.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
 <1398235595-13370-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398235595-13370-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:46:34AM +0100, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../bindings/regmap/regmap-endianness.txt          | 48 ++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> 
> diff --git a/Documentation/devicetree/bindings/regmap/regmap-endianness.txt b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> new file mode 100644
> index 0000000..1d838c5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> @@ -0,0 +1,48 @@
> +Device-Tree bindings for regmap endianness

As regmap is a Linux internal detail, I don't see why it needs to leak
into bindings.

> +Required properties:
> +- regmap-reg-endian: register endianness, see ../endianness/endianness.txt
> +  for detail.
> +- regmap-val-endian: value endianness, see ../endianness/endianness.txt for

I'm not familiar with regmap. What is the difference between register
and value endianness?

> +  detail.
> +
> +The Endianness flags supported by regmap:
> +DT properties           Macros
> +----------------------------------------
> +    'le'          REGMAP_ENDIAN_LITTLE
> +    'be'          REGMAP_ENDIAN_BIG
> +    'native'      REGMAP_ENDIAN_NATIVE
> +    Absent        REGMAP_ENDIAN_DEFAULT

As mentinoned earlier, I think we should stick to the common convention
of device-specific {big,little}-endian{,-*} boolean properties. The
common case might just be a simple big-endian property, with LE assumed
(or the inverse with a little-endian property).

Cheers,
Mark.
