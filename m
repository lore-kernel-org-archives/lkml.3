Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaKYH4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:56:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40199 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaKYH4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:56:46 -0500
Message-ID: <1416902195.3166.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] clk: Add PWM clock driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Janusz =?UTF-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Date: Tue, 25 Nov 2014 08:56:35 +0100
In-Reply-To: <20141125070720.12298.46343@quantum>
References: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
	 <20141125070720.12298.46343@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Montag, den 24.11.2014, 23:07 -0800 schrieb Mike Turquette:
> Quoting Philipp Zabel (2014-11-03 01:31:18)
> > Some board designers, when running out of clock output pads, decide to
> > (mis)use PWM output pads to provide a clock to external components.
> > This driver supports this practice by providing an adapter between the
> > PWM and clock bindings in the device tree. As the PWM bindings specify
> > the period in the device tree, this is a fixed clock.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > I'm resending this because last time the linux-pwm list was not in Cc:
> > So far I have not received any comments on the patch itself. I have used
> > it on a BoundaryDevices Nitrogen6X board to produce a master clock for
> > the OV5640 MIPI CSI-2 camera module.
> > 
> > Changes since v1:
> >  - none (rebased onto v3.18-rc3)
> 
> Hi Philipp,
> 
> Thanks for testing this. Is the Nitrogen6X board merged upstream? I'm OK
> with the patch but prefer to merge things when a consumer is ready to
> use it. I guess you are missing a patch to add the pwm-clock bits to the
> Nitrogen6X dts?

The Nitrogen6X board is merged upstream already, I used this dts patch
to register the clock:

diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 7628049..e2e7a22 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -130,6 +130,18 @@
 		power-supply = <&reg_3p3v>;
 		status = "okay";
 	};
+
+	mipi_mclk: mipi-mclk {
+		compatible = "pwm-clock";
+		clock-output-names = "mipi-mclk";
+		/* Note: since the PWM reference clock is 66 MHz, the highest
+		 * possible frequency with 50% duty cycle smaller than 27 MHz
+		 * is 16.5 MHz: <&pwm3 0 61>;
+		 * But we can also do 22 MHz with 33% duty cycle:
+		 */
+		pwms = <&pwm3 0 46>; /* 22 MHz */
+		#clock-cells = <0>;
+	};
 };
 
 &audmux {
-- 
2.1.1

regards
Philipp

