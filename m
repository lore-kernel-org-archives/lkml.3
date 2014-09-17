Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaIQRBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:01:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54473 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaIQRBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:01:10 -0400
Date: Wed, 17 Sep 2014 12:01:04 -0500
From: Nishanth Menon <nm@ti.com>
To: Sebastian Reichel <sre@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Documentation: devicetree: mfd: twl4030-power:
 Use the standard 'ti,system-power-controller' to mark power control
Message-ID: <20140917170104.GA26864@kahuna>
References: <1410957252-764-1-git-send-email-nm@ti.com>
 <1410957252-764-2-git-send-email-nm@ti.com>
 <20140917154400.GE30918@lee--X1>
 <20140917165529.GA24699@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917165529.GA24699@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:55-20140917, Sebastian Reichel wrote:
> On Wed, Sep 17, 2014 at 08:44:00AM -0700, Lee Jones wrote:
> > On Wed, 17 Sep 2014, Nishanth Menon wrote:
> > > ti,system-power-controller is more or less the standard way of
> > > indicating that the PMIC is the system wide power controller and hence
> > > may be used to switch off the system. Almost ALL TI PMIC drivers and
> > > many Maxim PMIC drivers follow the same style.
> > > 
> > > So support 'ti,system-power-controller' in addition to the usual
> > > 'ti,use_poweroff' to indicate that the PMIC instance has control for
> > > switching off the system.
> > > 
> > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > > ---
> > > 
> > > V2: picked up documentation suggestion from Sebastien
> > 
> > It would be good to get Sebastian's Ack.
> 
> Acked-By: Sebastian Reichel <sre@kernel.org>

Thanks.
> 
> [...]
> 
> > > +- ti,system-power-controller: This indicates that TWL4030 is the
> > > +  power supply master of the system. With this flag, the chip will
> > > +  initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when the
> > > +  system poweroffs.
> 
> One minor thing: While the documentation is updated you may want to
> fix the typo "will initiates" to "will initiate" (or just drop the
> "will").

Updated v3 patch with your ack and correction to drop "will" below. I
will assume I wont need to repost the following update. Do let me know
if you'd like me to.

---8<---
>From ae3bcfc74080b14f9fd0178f6526bf8f34a8c865 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Wed, 3 Sep 2014 13:55:02 -0500
Subject: [PATCH V3 1/2 ] Documentation: devicetree: mfd: twl4030-power: Use the
 standard 'ti,system-power-controller' to mark power control

ti,system-power-controller is more or less the standard way of
indicating that the PMIC is the system wide power controller and hence
may be used to switch off the system. Almost ALL TI PMIC drivers and
many Maxim PMIC drivers follow the same style.

So support 'ti,system-power-controller' in addition to the usual
'ti,use_poweroff' to indicate that the PMIC instance has control for
switching off the system.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-By: Sebastian Reichel <sre@kernel.org>
---
 .../devicetree/bindings/mfd/twl4030-power.txt      |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/twl4030-power.txt b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
index b9ee7b9..15a63e6 100644
--- a/Documentation/devicetree/bindings/mfd/twl4030-power.txt
+++ b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
@@ -23,8 +23,13 @@ down during off-idle. Note that this does not work on all boards
 depending on how the external oscillator is wired.
 
 Optional properties:
-- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
-		   SLEEP-to-OFF transition when the system poweroffs.
+
+- ti,system-power-controller: This indicates that TWL4030 is the
+  power supply master of the system. With this flag, the chip
+  initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when the
+  system poweroffs.
+
+- ti,use_poweroff: Deprecated name for ti,system-power-controller
 
 Example:
 &i2c1 {
-- 
1.7.9.5
-- 
Regards,
Nishanth Menon
