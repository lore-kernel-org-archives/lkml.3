Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbANKrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:47:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53559 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbANKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:47:12 -0500
Message-ID: <1421232418.3155.31.camel@pengutronix.de>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jyri Sarha <jsarha@ti.com>, Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2015 11:46:58 +0100
In-Reply-To: <20150113195415.GV12302@n2100.arm.linux.org.uk>
References: <20150112140456.GI12302@n2100.arm.linux.org.uk>
	 <20150112181341.4a53ea24@armhf>
	 <20150112175705.GN12302@n2100.arm.linux.org.uk>
	 <1421151718.4519.24.camel@pengutronix.de>
	 <20150113122715.GP12302@n2100.arm.linux.org.uk>
	 <20150113165411.5469930d@armhf>
	 <20150113160313.GR12302@n2100.arm.linux.org.uk>
	 <20150113200252.3dbfab14@armhf>
	 <20150113192648.GU12302@n2100.arm.linux.org.uk> <54B574CD.9020905@ti.com>
	 <20150113195415.GV12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

thanks for the clarification. 

Am Dienstag, den 13.01.2015, 19:54 +0000 schrieb Russell King - ARM
Linux:
[...]
> To represent that in DT, I would imagine we'd need something like this:
> 
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 	...
>         port@1 {                        /* AP1,2 = I2S */
> 		#address-cells = <1>;
> 		#size-cells = <0>;
>                 port-type = "i2s";
>                 reg = <0x01>;		/* WS */
>                 tda998x_i2s1: endpoint@2 {
> 			reg = <0x02>;	/* AP1 */
>                         remote-endpoint = <&audio1_i2s>;
>                 };
>                 tda998x_i2s2: endpoint@4 {
> 			reg = <0x04>;	/* AP2 */
>                         remote-endpoint = <&audio2_i2s>;
>                 };
>         };
>
> where audio1_i2s is operating in master mode, and audio2_i2s is
> operating in slave mode for both WS and SCLK.
> 
> If we can agree on that, then I'm happy with the proposed binding.
> (Remember that #address-cells and #size-cells are required in the
> parent where we have reg= in the child.)

So the question is mostly whether four I2S data pins with a single
shared WS/SCK input should be called "four I2S ports with shared clocks"
or "one I2S port with up to four data lanes". I'd lean towards the
latter.

How audio2_i2s is forced to synchronize its clock output to audio1_i2s
is a problem their bindings will have to handle.

regards
Philipp

