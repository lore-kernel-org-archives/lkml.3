Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3KGOWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:22:06 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:49652 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KGOWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:22:04 -0500
Date: Thu, 7 Nov 2013 15:16:43 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ARM: l2x0: add prefetch and power ctrl registers
 configuration support
Message-ID: <20131107141643.GB4440@lunn.ch>
References: <1383800872-7982-1-git-send-email-jszhang@marvell.com>
 <527B8BB4.3050200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527B8BB4.3050200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 01:46:44PM +0100, Sebastian Hesselbarth wrote:
> On 11/07/13 06:07, Jisheng Zhang wrote:
> >PL310 supports Prefetch offset/control register from r2p0 and Power
> >control register from r3p0. This patch adds the support to configure
> >these two registers if there are. The dt binding document is also updated.
> >
> >Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> >---
> >  Documentation/devicetree/bindings/arm/l2cc.txt |  4 ++++
> >  arch/arm/mm/cache-l2x0.c                       | 19 +++++++++++++++++++
> >  2 files changed, 23 insertions(+)
> >
> >diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> >index c0c7626..32cd08c 100644
> >--- a/Documentation/devicetree/bindings/arm/l2cc.txt
> >+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> >@@ -39,6 +39,10 @@ Optional properties:
> >  - arm,filter-ranges : <start length> Starting address and length of window to
> >    filter. Addresses in the filter window are directed to the M1 port. Other
> >    addresses will go to the M0 port.
> >+- arm,prefetch-ctrl : The value for Prefetch Offset/Control Register if there
> >+  is. This is a single cell.
> >+- arm,pwr-ctrl : The value for Power Control Register if there is. This is a
> >+  single cell.
> 
> Jisheng,
> 
> I did some research over L2x0/L310 aux-ctrl registers and possible
> properties for them. Both properties introduced here, just allow you
> to put in a magic number, while IMHO properties should better reflect
> the actual function rather than hard-coded values.
> 
> A quick look at L310 TRM for Power Control Register gives:
> 
> Bit 1: dynamic_clk_gating_en (1=enabled, 0=masked)
> Bit 0: standby mode en (1=enabled, 0=masked)
> 
> So, properties should one of:
> 
> (a) arm,dynamic-clock-gating = <0/1>
>     arm,standby-mode = <0/1>
> (b) arm,dynamic-clock-gating-enable/-disable;
>     arm,standby-mode-enable/-disable
> 
> If we want to have set/clear/don't touch behavior, I'd prefer (a) as
> it is easier to deal with in code. Moreover, -enable/-disable of (b)
> may not always fit the property name, so there will also be
> arm,no-feature-foo or arm,force-feature-bar.

Hi Sebastian

There have been some comments about properties with Boolean
values. Rather than having a Boolean, you simply don't list the
property.

What you have here is slightly different, since you have
set/clear/don't touch. How to represent this should be decided once by
the DT folks, and used consistently in all bindings.

    Andrew
