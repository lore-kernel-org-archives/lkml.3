Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaGVVoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:44:23 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40380 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaGVVoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:44:20 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: rk3188-radxarock: add GPIO IR receiver node
Date: Tue, 22 Jul 2014 23:45:47 +0200
Message-ID: <3433422.DZFVBm30W2@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140714190355.GA16904@gmail.com>
References: <1405253401-15534-1-git-send-email-b.galvani@gmail.com> <2390327.HZxnbJmfOO@diego> <20140714190355.GA16904@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juli 2014, 21:04:26 schrieb Beniamino Galvani:
> On Sun, Jul 13, 2014 at 02:37:40PM +0200, Heiko Stübner wrote:
> > Am Sonntag, 13. Juli 2014, 14:10:01 schrieb Beniamino Galvani:
> > > This adds a device tree node for the infrared receiver connected to a
> > > GPIO pin on the Radxa Rock.
> > > 
> > > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > > ---
> > > 
> > >  arch/arm/boot/dts/rk3188-radxarock.dts |   13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > > 
> > > diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts
> > > b/arch/arm/boot/dts/rk3188-radxarock.dts index 19d45b4..1d87bcb 100644
> > > --- a/arch/arm/boot/dts/rk3188-radxarock.dts
> > > +++ b/arch/arm/boot/dts/rk3188-radxarock.dts
> > > @@ -23,6 +23,13 @@
> > > 
> > >  		reg = <0x60000000 0x80000000>;
> > >  	
> > >  	};
> > > 
> > > +	ir_recv: ir-receiver {
> > > +		compatible = "gpio-ir-receiver";
> > > +		gpios = <&gpio0 10 1>;
> > > +		pinctrl-names = "default";
> > > +		pinctrl-0 = <&ir_recv_pin>;
> > > +	};
> > > +
> > 
> > hmm, on second glance, I'm actually not sure if this shouldn't belong in
> > the soc subnode, like the gpio-keys and leds.
> 
> (adding devicetree mailing list)
> 
> I placed the IR receiver under the root node after looking at what
> other boards do, for example:
> 
>   imx6dl-hummingboard.dts
>   imx6qdl-cubox-i.dtsi
>   dove-cubox.dts
> 
> On the other hand, if gpio-keys and leds are under the soc node
> probably it makes sense to follow the same rule also for the IR
> receiver.

your way was the right one actually ... using artificial subnodes is not 
encouraged at all - see comments I received , so the soc node itself also may 
go away.

I'll add the patch to my queue.


Heiko
