Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579AbaCUMRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:17:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56128 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759833AbaCUMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:17:45 -0400
Date: Fri, 21 Mar 2014 13:17:42 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 3/5] ARM: berlin/dt: add cpupll and syspll support to BG2Q
Message-ID: <20140321121741.GB6443@piout.net>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395402220-23503-4-git-send-email-alexandre.belloni@free-electrons.com>
 <532C2C71.4010703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532C2C71.4010703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 at 13:11:29 +0100, Sebastian Hesselbarth wrote :
> On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> 
> Alexandre,
> 
> Thanks for starting this! I'll start with the most obvious
> things first and have a closer look on it later.
> 

I will rework and wait for your other comments before sending a new
version. BTW, I've set up a branch on github if you want to try on your
platforms:

https://github.com/alexandrebelloni/linux.git topic/berlin-clk

> Missing commit description here.
> 
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >---
> >  arch/arm/boot/dts/berlin2q.dtsi | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> >index 07452a7483fa..19d2c82b0664 100644
> >--- a/arch/arm/boot/dts/berlin2q.dtsi
> >+++ b/arch/arm/boot/dts/berlin2q.dtsi
> >@@ -59,10 +59,26 @@
> >  		clock-frequency = <100000000>;
> >  	};
> >
> >+	syspll: syspll {
> 
> syspll: pll@ea0030 {
> 
> and sort it in between other SoC nodes below. This will
> most likely break clocks in v3.14 but v3.15 will receive
> proper clock init ordering.
> 

I will do across all the dtsi, don't bother repeating yourself :)

> >+		compatible = "marvell,berlin2q-pll";
> >+		clocks = <&smclk>;
> >+		#clock-cells = <0>;
> >+		reg = <0xf7ea0030 8>;
> >+	};
> >+
> >+	cpupll: cpupll {
> 
> dito.
> 
> >+		compatible = "marvell,berlin2q-pll";
> >+		clocks = <&smclk>;
> >+		#clock-cells = <0>;
> >+		reg = <0xf7dd0170 8>;
> >+	};
> >+
> >  	cpuclk: cpu-clock {
> >-		compatible = "fixed-clock";
> >+		compatible = "fixed-factor-clock";
> >+		clocks = <&cpupll>;
> >  		#clock-cells = <0>;
> >-		clock-frequency = <1200000000>;
> >+		clock-div = <1>;
> >+		clock-mult = <1>;
> 
> Hmm, you probably know better than me, but if cpuclk == cpupll
> is always true we don't need another clk layer here. If you
> can scale down cpuclk from cpupll and we just have no driver
> for it, I am fine with it.
> 

You can actually switch CPU clk from CPU pll to smclk. I'm not sure this
is completely useful yet though, probably for suspend ?

Also, while I'm not sure this is a good reason, other clocks are derived
from CPU pll and have another divider.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
