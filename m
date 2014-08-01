Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaHAKZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:25:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41137 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaHAKZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:25:40 -0400
Date: Fri, 1 Aug 2014 12:25:35 +0200
From: Robert Richter <rric@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ganapatrao Kulkarni <ganapatrao.kulkarni@caviumnetworks.com>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140801102535.GX4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <20140730154626.GD20162@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730154626.GD20162@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On 30.07.14 16:46:26, Mark Rutland wrote:

> > diff --git a/arch/arm64/boot/dts/thunder-88xx.dts b/arch/arm64/boot/dts/thunder-88xx.dts
> > new file mode 100644
> > index 000000000000..4cf20ac9138b
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/thunder-88xx.dts
> > @@ -0,0 +1,387 @@
> > +/*
> > + * Cavium Thunder DTS file
> > + *
> > + * Copyright (C) 2013, Cavium Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of
> > + * the License, or (at your option) any later version.
> > + */
> > +/dts-v1/;
> > +
> > +/* Reserving first 12MB of DDR for firmware */
> > +/memreserve/ 0x00000000 0x00c00000;
> 
> What exactly is this memreserve intended to protect at runtime?
> 
> The only item of runtime firmware I see in use below is PSCI on the
> secure side.
> 
> How is the kernel booted on this platform? UEFI?

We checked this and it seems we don't need memreserve. Mem is either
not visible to the kernel (ATF) or it is marked reserved by firmware
(UEFI). At the moment we don't see any other use cases. We will remove
this memreserve.

Thanks,

-Robert
