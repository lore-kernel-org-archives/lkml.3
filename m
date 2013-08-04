Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3HDBJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:09:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22141 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670Ab3HDBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:09:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18RcdYt2T5E0uYFeVR9NkTJ5y+L9kNc8RM=
Date: Sat, 3 Aug 2013 21:09:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: remove dmacap,memset from Device tree binding
Message-ID: <20130804010904.GB19280@titan.lakedaemon.net>
References: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372762453-12018-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130725153104.GH23879@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725153104.GH23879@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT Maintainers,

It's been a week with no comment.  Shall I assume it's ok to apply
this?

thx,

Jason.

On Thu, Jul 25, 2013 at 11:31:04AM -0400, Jason Cooper wrote:
> On Tue, Jul 02, 2013 at 12:54:12PM +0200, Sebastian Hesselbarth wrote:
> > DMA_MEMSET support has been removed, so update the device tree files
> > and corresponding binding documentation for Marvell SoCs.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > Cc: Russell King <linux@arm.linux.org.uk> 
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > Cc: Gregory CLEMENT <gregory.clement@free-electrons.com> 
> > Cc: devicetree-discuss@lists.ozlabs.org 
> > Cc: linux-kernel@vger.kernel.org 
> > Cc: linux-arm-kernel@lists.infradead.org 
> > ---
> >  Documentation/devicetree/bindings/dma/mv-xor.txt |    2 --
> >  arch/arm/boot/dts/armada-370.dtsi                |    2 --
> >  arch/arm/boot/dts/armada-xp.dtsi                 |    2 --
> >  arch/arm/boot/dts/dove.dtsi                      |    2 --
> >  arch/arm/boot/dts/kirkwood.dtsi                  |    2 --
> >  arch/arm/boot/dts/orion5x.dtsi                   |    1 -
> >  6 files changed, 0 insertions(+), 11 deletions(-)
> 
> Adding the new devicetree ml to the Cc:
> 
> I'm fine with the changes to the dts{i} files, but I think the binding
> document should be handled differently.
> 
> thx,
> 
> Jason.
> 
> > 
> > diff --git a/Documentation/devicetree/bindings/dma/mv-xor.txt b/Documentation/devicetree/bindings/dma/mv-xor.txt
> > index 7c6cb7f..68f7004 100644
> > --- a/Documentation/devicetree/bindings/dma/mv-xor.txt
> > +++ b/Documentation/devicetree/bindings/dma/mv-xor.txt
> > @@ -14,7 +14,6 @@ properties:
> >  
> >  And the following optional properties:
> >  - dmacap,memcpy to indicate that the XOR channel is capable of memcpy operations
> > -- dmacap,memset to indicate that the XOR channel is capable of memset operations
> >  - dmacap,xor to indicate that the XOR channel is capable of xor operations
> >  
> >  Example:
> > @@ -35,6 +34,5 @@ xor@d0060900 {
> >  	      interrupts = <52>;
> >  	      dmacap,memcpy;
> >  	      dmacap,xor;
> > -	      dmacap,memset;
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
> > index fa3dfc6..a315ad1 100644
> > --- a/arch/arm/boot/dts/armada-370.dtsi
> > +++ b/arch/arm/boot/dts/armada-370.dtsi
> > @@ -132,7 +132,6 @@
> >  					interrupts = <52>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -					dmacap,memset;
> >  				};
> >  			};
> >  
> > @@ -151,7 +150,6 @@
> >  					interrupts = <95>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -					dmacap,memset;
> >  				};
> >  			};
> >  
> > diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
> > index 416eb94..4b3dd56 100644
> > --- a/arch/arm/boot/dts/armada-xp.dtsi
> > +++ b/arch/arm/boot/dts/armada-xp.dtsi
> > @@ -114,7 +114,6 @@
> >  					interrupts = <52>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -					dmacap,memset;
> >  				};
> >  			};
> >  
> > @@ -134,7 +133,6 @@
> >  					interrupts = <95>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -					dmacap,memset;
> >  				};
> >  			};
> >  
> > diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> > index 6cab468..2cef34f 100644
> > --- a/arch/arm/boot/dts/dove.dtsi
> > +++ b/arch/arm/boot/dts/dove.dtsi
> > @@ -232,7 +232,6 @@
> >  
> >  			channel1 {
> >  				interrupts = <40>;
> > -				dmacap,memset;
> >  				dmacap,memcpy;
> >  				dmacap,xor;
> >  			};
> > @@ -253,7 +252,6 @@
> >  
> >  			channel1 {
> >  				interrupts = <43>;
> > -				dmacap,memset;
> >  				dmacap,memcpy;
> >  				dmacap,xor;
> >  			};
> > diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
> > index 9809fc1..078637c 100644
> > --- a/arch/arm/boot/dts/kirkwood.dtsi
> > +++ b/arch/arm/boot/dts/kirkwood.dtsi
> > @@ -126,7 +126,6 @@
> >  			      interrupts = <6>;
> >  			      dmacap,memcpy;
> >  			      dmacap,xor;
> > -			      dmacap,memset;
> >  			};
> >  		};
> >  
> > @@ -146,7 +145,6 @@
> >  			      interrupts = <8>;
> >  			      dmacap,memcpy;
> >  			      dmacap,xor;
> > -			      dmacap,memset;
> >  			};
> >  		};
> >  
> > diff --git a/arch/arm/boot/dts/orion5x.dtsi b/arch/arm/boot/dts/orion5x.dtsi
> > index 892c64e..f82ece7 100644
> > --- a/arch/arm/boot/dts/orion5x.dtsi
> > +++ b/arch/arm/boot/dts/orion5x.dtsi
> > @@ -120,7 +120,6 @@
> >  			      interrupts = <31>;
> >  			      dmacap,memcpy;
> >  			      dmacap,xor;
> > -			      dmacap,memset;
> >  			};
> >  		};
> >  
> > -- 
> > 1.7.2.5
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
