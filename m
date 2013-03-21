Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3CUTSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:18:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:55971 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3CUTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:18:13 -0400
Date: Thu, 21 Mar 2013 20:18:07 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64
 bits
Message-ID: <20130321201807.7cb04978@skate>
In-Reply-To: <201303211903.52383.arnd@arndb.de>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
	<1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
	<514B4A79.1070501@gmail.com>
	<201303211903.52383.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Thu, 21 Mar 2013 19:03:52 +0000, Arnd Bergmann wrote:
> On Thursday 21 March 2013, Rob Herring wrote:
> > >       soc {
> > > -             #address-cells = <1>;
> > > -             #size-cells = <1>;
> > > +             #address-cells = <2>;
> > > +             #size-cells = <2>;
> > 
> > If all the addresses for the soc bus are below 4GB or even within a 4GB
> > range if using the ranges property, then changing all this and
> > everything below it is kind of pointless.
> 
> Good point. We'll probably also have to change it all again when we add a new
> binding for that bus in 3.10, so it makes sense to change it only once.

In the mean time can we do something like:

	soc {
		compatible = "simple-bus";
		range = <...>;

		[... all the peripherals ...]
	};

with the range = <...> property converting the peripheral registers
base address (expressed as offsets in the reg = <...> properties of the
subnodes) into the absolute physical address?

I'm planning to work on the DT binding for the mvebu-mbus driver as
soon as the PCIe driver gets accepted, but it would be good to have an
intermediate solution to get the LPAE support in.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
