Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaKJPKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:10:13 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaKJPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:10:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CWSRXTVMfUeBZB1xit4oD
Date: Mon, 10 Nov 2014 07:09:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg
Subject: Re: dtb size limit? was Re: Tiny dts change breaks boot on n900
Message-ID: <20141110150915.GH31454@atomide.com>
References: <20141110123118.GA31134@amd>
 <20141110125806.GA16650@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110125806.GA16650@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141110 04:59]:
> On Mon 2014-11-10 13:31:18, Pavel Machek wrote:
> > Hi!
> > 
> > I'm confused:
> > 
> > This fixes boot on n900. Strange thing is ... adp1653 driver is not
> > even compiled in -- it is module.
> > 
> > It looks like tiny change in dts noone should care about breaks
> > boot... I don't even have adp1653 device parsing code written.
> > 
> > Something similar happened before -- change in device tree order broke
> > boot.
> > 
> > Any ideas? What is going on?
> 
> If I replace the blog below with
> 
>  a = <1>;
>  b = <2>;
>  c = <3>;
>  d = <4>;
> 
> Resulting kernel boots. Replacing it with
> 
>  a-really-long-attribute-name-hopefully-this-breaks-stuff = <1>;
>  b = <2>;
>  c = <3>;
>  d = <4>;
> 
> Breaks the boot. I'm using dtb append option. Any ideas? Nonbooting
> dtb is 68910 bytes.
> 
> pavel@amd:/data/l/linux-n900$ ls -al arch/arm/boot/dts/omap3-n900.dtb 
> -rw-r--r-- 1 pavel pavel 68910 Nov 10 13:52 arch/arm/boot/dts/omap3-n900.dtb
> 
> I removed some "smsc,lan91c94" settings, and it boots again. Weird.

Seems like we may still have some issues with the relocation if
it's size related. Or a regression maybe?

See for example commit 5ffb04f6690d ("ARM: zImage: make sure appended
DTB doesn't get overwritten by kernel .bss")

Regards,

Tony

> > diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> > index f3118bf..557a19e 100644
> > --- a/arch/arm/boot/dts/omap3-n900.dts
> > +++ b/arch/arm/boot/dts/omap3-n900.dts
> > @@ -565,11 +565,6 @@
> >  	adp1653: adp1653@30 {
> >  		compatible = "ad,adp1653";
> >  		reg = <0x30>;
> > -
> > -		max-flash-timeout-usec = <500000>;
> > -		max-flash-intensity-mA = <0>;
> > -		max-torch-intensity-mA = <0>;
> > -		max-indicator-intensity-uA = <0>;
> >  	};
> >  };
> >  
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
