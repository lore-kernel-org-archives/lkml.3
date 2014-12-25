Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaLYOOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 09:14:11 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:50350 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaLYOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 09:14:06 -0500
Date: Thu, 25 Dec 2014 15:12:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141225141240.GJ19265@lunn.ch>
References: <20141215203855.GA28940@anne>
 <20141222125750.GA29163@anne>
 <549C0C3C.8060601@gmail.com>
 <20141225133109.GI19265@lunn.ch>
 <549C1465.6030909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549C1465.6030909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Hi Sebastian
> >
> >I'm not sure what you mean here. The binding Documentation says:
> 
> I was hoping that using phys/phy-names would allow us to get rid of
> nr-ports property. I haven't checked the corresponding code and likely
> will not before next year, but we should try to get rid of the nr-ports
> property completely.
> 
> >Required Properties:
> >- compatibility : "marvell,orion-sata" or "marvell,armada-370-sata"
> >- reg           : Address range of controller
> >- interrupts    : Interrupt controller is using
> >- nr-ports      : Number of SATA ports in use.
> >
> >Optional Properties:
> >- phys          : List of phandles to sata phys
> >- phy-names     : Should be "0", "1", etc, one number per phandle
> >
> >The optional phys/phy-names have just been added to
> >kirkwood-6192.dtsi.
> 
> Yeah, saw that patch after the review.. and my understanding of the
> phys/phy-names properties is that
> (a) they allow to count the number of _available_ ports
> (b) they allow to determine the number of _used_ ports
> (c) they allow to e.g. disable port 0 but enable port 1
> 
> while nr-ports only allows (a). You can derive (b) only if you use
> the first out of two but you cannot do (c) with nr-ports.
> 
> Which is why we introduced the phys/phy-names properties.

We introduced them for turning the phys on and off.

We don't do any derivation from this information. It is the same for
all devices, since it is in the kirkwood-*.dtsi file, not per board.

Also, orion5x does not allow such control of the phys, they are always
on. So i don't know if we can derive anything from this information,
since it is not always present.

    Andrew
