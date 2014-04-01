Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaDAGXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:23:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37151 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaDAGXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:23:12 -0400
Date: Tue, 1 Apr 2014 08:23:06 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Message-ID: <20140401062306.GS17250@pengutronix.de>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <5339A036.6090703@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5339A036.6090703@codethink.co.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:22:18 up 219 days, 15:53, 42 users,  load average: 0.08, 0.05,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 06:04:54PM +0100, Ben Dooks wrote:
> On 31/03/14 17:41, Sylwester Nawrocki wrote:
> >This function adds a helper function to configure clock parents and rates
> >as specified in clock-parents, clock-rates DT properties for a consumer
> >device and a call to it before driver is bound to a device.
> 
> [snip]
> 
> tree/bindings/clock/clock-bindings.txt
> b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >index 700e7aa..59fbb4e 100644
> >--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >@@ -132,3 +132,45 @@ clock signal, and a UART.
> >    ("pll" and "pll-switched").
> >  * The UART has its baud clock connected the external oscillator and its
> >    register clock connected to the PLL clock (the "pll-switched" signal)
> >+
> >+==Assigned clock parents and rates==
> >+
> >+Some platforms require static initial configuration of parts of the clocks
> >+controller. Such a configuration can be specified in a clock consumer node
> >+through clock-parents and clock-rates DT properties. The former should
> >+contain a list of parent clocks in form of phandle and clock specifier pairs,
> >+the latter the list of assigned clock frequency values (one cell each).
> >+
> >+    uart@a000 {
> >+        compatible = "fsl,imx-uart";
> >+        reg = <0xa000 0x1000>;
> >+        ...
> >+        clocks = <&clkcon 0>, <&clkcon 3>;
> >+        clock-names = "baud", "mux";
> >+
> >+        clock-parents = <0>, <&pll 1>;
> >+        clock-rates = <460800>;
> >+    };
> >+
> >+In this example the pll is set as parent of "mux" clock and frequency of "baud"
> >+clock is specified as 460800 Hz.
> >+
> >+Configuring a clock parent and rate through the device node that uses
> >+the clock can be done only for clocks that have a single user. Specifying
> >+conflicting parent or rate configuration in multiple consumer nodes for
> >+a shared clock is forbidden.
> >+
> >+Configuration of common clocks, which affect multiple consumer devices
> >+can be specified in a dedicated 'assigned-clocks' subnode of a clock
> >+provider node, e.g.:
> >+
> >+    clkcon {
> >+        ...
> >+        #clock-cells = <1>;
> >+
> >+        assigned-clocks {
> >+            clocks = <&clkcon 16>, <&clkcon 17>;
> >+            clock-parents = <0>, <&clkcon 1>;
> >+            clock-rates = <200000>;
> >+        };
> >+    };
> 
> How do you support not-setting a rate for a clock?

Not setting a rate is supported by specifying the rate to 0. That should
be documented of course.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
