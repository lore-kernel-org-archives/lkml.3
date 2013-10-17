Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JQJvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:51:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38504 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3JQJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:51:15 -0400
Message-ID: <1382003190.4093.38.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCHv1 8/8] Documentation: Add device tree bindings for
 Freescale VF610 sound.
From: Lucas Stach <l.stach@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, timur@tabi.org, lgirdwood@gmail.com,
        broonie@kernel.org, mark.rutland@arm.com, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, tiwai@suse.de, b18965@freescale.com,
        perex@perex.cz, LW@KARO-electronics.de, linux@arm.linux.org.uk,
        b42378@freescale.com, oskar@scara.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, ian.campbell@citrix.com,
        pawel.moll@arm.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, rob@landley.net, r64188@freescale.com,
        shawn.guo@linaro.org, linuxppc-dev@lists.ozlabs.org
Date: Thu, 17 Oct 2013 11:46:30 +0200
In-Reply-To: <1382000477-17304-9-git-send-email-Li.Xiubo@freescale.com>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
	 <1382000477-17304-9-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 17.10.2013, 17:01 +0800 schrieb Xiubo Li:
> This adds the Document for Freescale VF610 sound driver under
> Documentation/devicetree/bindings/sound/.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/sound/fsl-sgtl5000.txt     | 52 ++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt
> 
> diff --git a/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt b/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt
> new file mode 100644
> index 0000000..43e350f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt

This document name is overly generic, there are more than one FSL
platforms with SGTL5000 codecs. Please include the vf610 here.

> @@ -0,0 +1,52 @@
> +Freescale VF610 audio complex with SGTL5000 codec
> +
> +Required properties:
> +- compatible: "fsl,vf610-sgtl5000"
> +- model: The user-visible name of this sound complex.
> +- saif-controllers: The phandle list of the SAI controller.
> +- audio-codec: The phandle of the SGTL5000 audio codec.
> +- audio-routing : A list of the connections between audio components.
> +  Each entry is a pair of strings, the first being the connection's sink,
> +  the second being the connection's source. Valid names could be power
> +  supplies, SGTL5000 pins, and the jacks on the board:
> +
> +  -- Power supplies:
> +     * Mic Bias
> +
> +  -- SGTL5000 pins:
> +     * MIC_IN
> +     * LINE_IN
> +     * HP_OUT
> +     * LINE_OUT
> +
> +  -- Board connectors:
> +     * Mic Jack
> +     * Line In Jack
> +     * Headphone Jack
> +     * Line Out Jack
> +     * Ext Spk
> +
> +Example:
> +
> +sound {
> +	compatible = "fsl,vf610-sgtl5000";
> +	model = "vf610-sgtl5000";
> +	saif-controller = <&sai2>;
> +	audio-codec = <&codec>;
> +	audio-routing =
> +		"MIC_IN", "Mic Jack",
> +		"Mic Jack", "Mic Bias",
> +		"LINE_IN", "Line In Jack",
> +		"Headphone Jack", "HP_OUT",
> +		"Ext Spk", "LINE_OUT";
> +};
> +
> +&i2c0 {
> +	...
> +
> +	codec: sgtl5000@0a {
> +	       compatible = "fsl,sgtl5000";
> +	       reg = <0x0a>;
> +	       clocks = <&clks VF610_CLK_SAI2>;
> +       };
> +};

-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

