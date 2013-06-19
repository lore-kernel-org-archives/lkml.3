Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3FSPPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:15:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46309 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3FSPPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:15:03 -0400
Message-ID: <1371654898.3173.11.camel@hornet>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Date: Wed, 19 Jun 2013 16:14:58 +0100
In-Reply-To: <201306191703.35182.arnd@arndb.de>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <201306191437.20759.arnd@arndb.de> <1371646530.3867.12.camel@hornet>
	 <201306191703.35182.arnd@arndb.de>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jun 2013 15:14:59.0387 (UTC) FILETIME=[C39168B0:01CE6CFF]
X-MC-Unique: 113061916150001101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 16:03 +0100, Arnd Bergmann wrote:
> On Wednesday 19 June 2013, Pawel Moll wrote:
> > ... but sysreg does more than just that. In particular it provides a
> > pseudo-gpio controller (I don't think you want to hide this behind the
> > syscon) and it can act as a bridge to the configuration bus - see
> > below. In short - no, I don't think sysreg driver can disappear. It can
> > be reduced in size, yes.
> 
> As I said, the gpio part can be a separate driver that just handles
> gpio, 

I've already promised Samuel that.

> and I think the configuration bridge can be part of the
> vexpress-config driver, building on top of syscon. I'm not completely
> sure about the latter part.

I don't think so, no. I appreciate what you are trying to say, but I
object to mixing ideas for the sake of reducing number of files. The
config infrastructure is completely independent from the sysreg. Each of
them can exist on its own. The only common thing is a (slightly baroque)
communication interface between those two.

> > > > > 3. Move vexpress-config into drivers/bus as it is (however I see no one
> > > > > in MAINTAINERS for this directory)
> > > > ISTR that Arnd originally created that directory, so he may help here.
> > > > Arnd also had some concerns about implementing this code as a bus,
> > > > mostly about it not being a discoverable bus. IMHO that's a valid
> > > > concern, and this is why you ended up putting it under MFD which can be
> > > > seen as some sort of platform devices bus. But I still believe the bus
> > > > API would make this code look cleaner and easier to maintain.
> > > 
> > > Sorry, I don't see why it would be a bus. I assume that there is code
> > > missing somewhere that is not yet merged, right?
> > 
> > Well, different VE components (configuration microcontrollers on
> > motherboard and daughterboards in particular) talk to each other over a
> > bus (an SPI derivative, in case you were wondering). So there is a bus.
> > A non-discoverable one, but it does 42 (approximately ;-) different
> > things. We already have: clk, hwmon, regulator and reset drivers using
> > it.
> 
> Ah, got it. In this case I think what you are looking for is a custom
> 'regmap' interface that abstracts those devices. Regmap can already
> cover i2c, spi and mmio based sets of registers (syscon is one example
> for mmio), and IIRC there is a simple way of extending it to other
> register-level interfaces like this one.

This is an interesting idea. The thing that worries me the most is its
early (pre-slab) availability, but I will give it a try.

Paweł


