Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3CUVQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:16:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3CUVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:16:18 -0400
Date: Thu, 21 Mar 2013 22:16:13 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64
 bits
Message-ID: <20130321221613.53a48845@skate>
In-Reply-To: <20130321203751.GP21478@lunn.ch>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
	<1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
	<20130321201533.GN21478@lunn.ch>
	<20130321212236.1015295d@skate>
	<20130321203751.GP21478@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Thu, 21 Mar 2013 21:37:51 +0100, Andrew Lunn wrote:

> > And I'm not sure the SDRAM address decoding windows allows to split the
> > first 4 GB of RAM into two areas, one that would be mapped starting at
> > physical address 0x0, and another area that would be mapped at a
> > different address (above 4 GB).
> 
> So why not map the whole SDRAM above 4GB physical address?

As Lior rightly pointed out to me, this would prevent any device from
DMA-ing to or from the RAM. Devices can only access the first 32 bits
of the physical address space. So there must be some RAM below 4 GB.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
