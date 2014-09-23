Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaIWRCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:02:49 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55514 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaIWRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:02:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 19:02:33 +0200
Message-ID: <5150779.ibmzDh88cj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5421A28E.7060600@gmail.com>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <9401592.hUYDkriFVO@wuerfel> <5421A28E.7060600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KLzhCvNdmDgXUQmOJxRsqq9zbq8I9TxqmGClU/JD2Xr
 OKMZNJ/jmJf37JPbDrhTaSDNN28IcD8SnzdmfntCyropDVUHZK
 8t5h1oVjNKIT8tfxjEcWObW8D/eWlOJByjSYKi1SG/WOgOQ31e
 /uINY6Zo1mMvMRs4qXirFFY/JPkgc7Q8bmAxzsaaXxen6aSeFa
 +/70g9R0XEDABQoSmyppak1HEbmTfy4wNotI3bSfNKlIkH17Yt
 wqA6jaYVFUXxrWe/bL3oheIUk/VhCbHjtgbSXG4O38H0W6y5f5
 OhS9JdEKL5iyvjdrIVeQwtVWgclQFDamriITxvmH0V0RANpS6S
 jklcUPejQ47OfUU63vy8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 18:40:46 Sebastian Hesselbarth wrote:
> On 09/23/2014 06:29 PM, Arnd Bergmann wrote:
> > On Tuesday 23 September 2014 17:45:52 Sebastian Hesselbarth wrote:
> >> For reference, this is what we have for MVEBU SoCs with multiple ports
> >> per controller:
> >>
> >> eth: ethernet-ctrl@72000 {
> >>          compatible = "marvell,orion-eth";
> ...
> >>          reg = <0x72000 0x4000>;
> ...
> >>
> >>          ethernet-port@0 {
> >>                  compatible = "marvell,orion-eth-port";
> ...
> >>                  phy-handle = <&ethphy>;
> >>          };
> >> };
> >>
> >> mdio: mdio-bus@72004 {
> >>          compatible = "marvell,orion-mdio";
> ...
> >>          reg = <0x72004 0x84>;
> ..
> >>          ethphy: ethernet-phy {
> >>                  /* set phy address in board file */
> >>          };
> >> };
> 
> > But in this example, you have the same registers and the same
> > clocks in two nodes, which are even used by the same device driver
> > at the moment. It's not a big issue, but my feeling is that Antoine's
> > approach was actually better because it more closely reflects
> > the way that the hardware is built.
> 
> I was not referring to the separate mdio bus node, but putting the
> ethernet-phy node as a child of ethernet-ctrl.

Ah, got it (I think). Yes, that makes sense.

The part I don't understand yet is how one uses multiple ports. pxa168_eth.c
seems to be written with the assumption that only one port is ever used at
a time, while mv643xx_eth.c can actually use multiple ports simultaneously.

Do you think that is that a hardware limitation of pxa168_eth or a feature
that nobody so far has needed from the driver?

If there is only one port and we just have to know which one that is,
I don't think we need the child nodes, but if one can have multiple
ports operate independently then the driver will need a rework 
to actually be usable with that configuration.


	Arnd
