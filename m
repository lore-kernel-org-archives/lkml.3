Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3EHXyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:54:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51221 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755969Ab3EHXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:54:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18oJD0lYWYbYosJPKWcl8J1
Date: Wed, 8 May 2013 16:54:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: "Gupta, Pekon" <pekon@ti.com>, linux-mtd@lists.infradead.org,
        b-cousson@ti.com, linux@arm.linux.org.uk,
        avinash philip <avinashphilip@ti.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gururaja.hebbar@ti.com, hvaibhav@ti.com, zonque@gmail.com,
        jacmet@sunsite.dk
Subject: Re: [v2, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
Message-ID: <20130508235404.GX32546@atomide.com>
References: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com>
 <517F5126.5000509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517F5126.5000509@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sekhar Nori <nsekhar@ti.com> [130429 22:11]:
> 
> On 4/29/2013 1:25 PM, Gupta, Pekon wrote:
> > From: avinash philip <avinashphilip@ti.com>
> > 
> > NAND flash connected in am335x-evm on GPMC controller. This patch adds
> > device tree node in am3355-evm with GPMC contoller timing for NAND flash
> > interface, NAND partition table, ECC scheme, elm handle id.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > Tested-by: Pekon Gupta <pekon@ti.com>
> > 
> > ---
> > arch/arm/boot/dts/am335x-evm.dts |   98 +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 97 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> > index 0423298..1c2fd89 100644
> > --- a/arch/arm/boot/dts/am335x-evm.dts
> > +++ b/arch/arm/boot/dts/am335x-evm.dts
> > @@ -26,7 +26,8 @@
> >  
> >  	am33xx_pinmux: pinmux@44e10800 {
> >  		pinctrl-names = "default";
> > -		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0>;
> > +		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0
> > +			&nandflash_pins_s0>;
> 
> Why add this to the board level fallback (called pinctrl hogs, I think)?
> This can be part of nand node you added below so that the pinctrl will
> take effect when nand gets probed instead of all the time.

Yes we should have all the pinctrl entries under the related drivers.
This makes it easy remux pins during runtime if needed, and also
allows unloading pinctrl-single.ko for development.

Regards,

Tony
