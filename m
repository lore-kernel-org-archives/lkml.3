Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaB1WlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:41:09 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65368 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752116AbaB1WlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:41:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19VXkEPV1iHg4xZ14bgN8U6
Date: Fri, 28 Feb 2014 14:40:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Nishanth Menon <nm@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Mike Turquette <mturquette@linaro.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: OMAP3+: add clock nodes for CPU
Message-ID: <20140228224053.GO13624@atomide.com>
References: <1391019557-22313-1-git-send-email-nm@ti.com>
 <1391019557-22313-3-git-send-email-nm@ti.com>
 <530633E8.3000608@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530633E8.3000608@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tero Kristo <t-kristo@ti.com> [140220 09:00]:
> On 01/29/2014 08:19 PM, Nishanth Menon wrote:
> >OMAP34xx, AM3517 and OMAP36xx platforms use dpll1 clock.
> >
> >OMAP443x, OMAP446x, OMAP447x, OMAP5, DRA7, AM43xx platforms use
> >dpll_mpu clock.
> >
> >Latency used is the generic latency defined in omap-cpufreq
> >driver.
> >
> >Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Looks good to me.
> 
> Acked-by: Tero Kristo <t-kristo@ti.com>

Thanks applying into omap-for-v3.15/dt.

Regards,

Tony

> 
> >---
> >  arch/arm/boot/dts/am33xx.dtsi |    4 ++++
> >  arch/arm/boot/dts/am4372.dtsi |    5 +++++
> >  arch/arm/boot/dts/dra7.dtsi   |    5 +++++
> >  arch/arm/boot/dts/omap3.dtsi  |    5 +++++
> >  arch/arm/boot/dts/omap4.dtsi  |    5 +++++
> >  arch/arm/boot/dts/omap5.dtsi  |    6 ++++++
> >  6 files changed, 30 insertions(+)
> >
> >diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> >index 6d95d3d..4bbba26 100644
> >--- a/arch/arm/boot/dts/am33xx.dtsi
> >+++ b/arch/arm/boot/dts/am33xx.dtsi
> >@@ -58,6 +58,10 @@
> >  				275000  1125000
> >  			>;
> >  			voltage-tolerance = <2>; /* 2 percentage */
> >+
> >+			clocks = <&dpll_mpu_ck>;
> >+			clock-names = "cpu";
> >+
> >  			clock-latency = <300000>; /* From omap-cpufreq driver */
> >  		};
> >  	};
> >diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> >index c6bd4d9..33798d9 100644
> >--- a/arch/arm/boot/dts/am4372.dtsi
> >+++ b/arch/arm/boot/dts/am4372.dtsi
> >@@ -33,6 +33,11 @@
> >  			compatible = "arm,cortex-a9";
> >  			device_type = "cpu";
> >  			reg = <0>;
> >+
> >+			clocks = <&dpll_mpu_ck>;
> >+			clock-names = "cpu";
> >+
> >+			clock-latency = <300000>; /* From omap-cpufreq driver */
> >  		};
> >  	};
> >
> >diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> >index 1fd75aa..ce591e5 100644
> >--- a/arch/arm/boot/dts/dra7.dtsi
> >+++ b/arch/arm/boot/dts/dra7.dtsi
> >@@ -47,6 +47,11 @@
> >  				1000000	1060000
> >  				1176000	1160000
> >  				>;
> >+
> >+			clocks = <&dpll_mpu_ck>;
> >+			clock-names = "cpu";
> >+
> >+			clock-latency = <300000>; /* From omap-cpufreq driver */
> >  		};
> >  		cpu@1 {
> >  			device_type = "cpu";
> >diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> >index a5fc83b..01f2b3b 100644
> >--- a/arch/arm/boot/dts/omap3.dtsi
> >+++ b/arch/arm/boot/dts/omap3.dtsi
> >@@ -35,6 +35,11 @@
> >  			compatible = "arm,cortex-a8";
> >  			device_type = "cpu";
> >  			reg = <0x0>;
> >+
> >+			clocks = <&dpll1_ck>;
> >+			clock-names = "cpu";
> >+
> >+			clock-latency = <300000>; /* From omap-cpufreq driver */
> >  		};
> >  	};
> >
> >diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> >index d3f8a6e..ce87996 100644
> >--- a/arch/arm/boot/dts/omap4.dtsi
> >+++ b/arch/arm/boot/dts/omap4.dtsi
> >@@ -36,6 +36,11 @@
> >  			device_type = "cpu";
> >  			next-level-cache = <&L2>;
> >  			reg = <0x0>;
> >+
> >+			clocks = <&dpll_mpu_ck>;
> >+			clock-names = "cpu";
> >+
> >+			clock-latency = <300000>; /* From omap-cpufreq driver */
> >  		};
> >  		cpu@1 {
> >  			compatible = "arm,cortex-a9";
> >diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> >index a72813a..8bb4134 100644
> >--- a/arch/arm/boot/dts/omap5.dtsi
> >+++ b/arch/arm/boot/dts/omap5.dtsi
> >@@ -49,6 +49,12 @@
> >  				1000000 1060000
> >  				1500000 1250000
> >  			>;
> >+
> >+			clocks = <&dpll_mpu_ck>;
> >+			clock-names = "cpu";
> >+
> >+			clock-latency = <300000>; /* From omap-cpufreq driver */
> >+
> >  			/* cooling options */
> >  			cooling-min-level = <0>;
> >  			cooling-max-level = <2>;
> >
> 
