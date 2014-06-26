Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaFZHbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:31:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41316 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360AbaFZHbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:31:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hUYbe8RNWZadi577zxHNN
Date: Thu, 26 Jun 2014 00:31:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, rnayak@ti.com, balbi@ti.com, nsekhar@ti.com,
        kishon@ti.com, george.cherian@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
Message-ID: <20140626073115.GD28884@atomide.com>
References: <1403700996-27105-1-git-send-email-rogerq@ti.com>
 <53AB4CE0.6020705@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AB4CE0.6020705@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140625 15:29]:
> On 06/25/2014 07:56 AM, Roger Quadros wrote:
> > The SATA and USB PHYs need the 1.8V and 3.3V supplies.
> > The PHY drivers/framework don't yet support regulator
> > supply so we have to keep these regulators always-on till
> > then.
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > ---
> >  arch/arm/boot/dts/dra7-evm.dts | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> > index 4adc280..99a1f79 100644
> > --- a/arch/arm/boot/dts/dra7-evm.dts
> > +++ b/arch/arm/boot/dts/dra7-evm.dts
> > @@ -241,6 +241,7 @@
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> >  					regulator-boot-on;
> > +					regulator-always-on;
> >  				};
> >  
> >  				ldo9_reg: ldo9 {
> > @@ -266,6 +267,7 @@
> >  					regulator-min-microvolt = <3300000>;
> >  					regulator-max-microvolt = <3300000>;
> >  					regulator-boot-on;
> > +					regulator-always-on;
> >  				};
> >  			};
> >  		};
> > 
> 
> Why not fix phy driver/framework as needed? the trouble is people
> always forget to remove always-on... who actually audits old logs and
> fixes stuff back up?

Yes I agree let's not play with the regulator-always-on unless
absolutely necessary.

Regards,

Tony
