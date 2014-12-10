Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbaLJU40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:56:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbaLJU4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:56:25 -0500
Date: Wed, 10 Dec 2014 21:56:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "sre@debian.org" <sre@debian.org>, "sre@ring0.de" <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "khilman@kernel.org" <khilman@kernel.org>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "ivo.g.dimitrov.75@gmail.com" <ivo.g.dimitrov.75@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: Re: BCM2048 bluetooth connected over OMAP serial
Message-ID: <20141210205622.GA25286@amd>
References: <20141210164333.GA3154@amd>
 <11367725.nphhSzdtpK@wuerfel>
 <20141210184203.GA28150@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210184203.GA28150@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-12-10 18:42:03, Mark Rutland wrote:
> On Wed, Dec 10, 2014 at 05:02:42PM +0000, Arnd Bergmann wrote:
> > On Wednesday 10 December 2014 17:43:33 Pavel Machek wrote:
> > > 
> > > So, there's bluetooth chip that's connected to the SoC by UART and some
> > > GPIOs. What would be right representation in the device tree?
> > > Something like this?
> > > 
> > >         bluetooth {
> > >                   compatible = "broadcom,bcm2048";
> > >                   uart = <&uart2>;
> > >                   reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
> > >                   host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
> > >                   bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */
> > >                   chip-type = >;
> > >                   bt-sysclk = <2>;
> > >                   reset-gpio-shared = <0>;
> > >         };
> > > 
> > > Is there some way to prevent OMAP tty driver from binding to the
> > > device and exporting the device to userspace?
> > 
> > I think from the driver perspective, you want this to be a tty line
> > discipline rather than a driver that attaches to the physical
> > uart.
> > 
> > For the DT representation, I fear we haven't got a precedent. A uart
> > phandle sounds reasonable, but there might be other ways to do it
> > and we should consider if there are better alternatives. It could
> > possibly be a child node of the uart, but that would require other
> > infrastructure in the kernel because we don't currently create
> > devices for those.
> 
> I think the child node is the way to go; that would match what we do for
> I2C and SPI. We might need new infrastructure, but I don't think we
> should treat this differently simlpy because we don't have that yet.

Well, uart in this case looks more like a GPIO than an I2C (no
addressing, just few wires). And we do phandle for GPIOs.

Actually, the chip also has PCM, analog audio, and "pc compatible?"
connections, plus some connection to WIFI. So we may need more
phandles there....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
