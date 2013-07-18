Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3GRRYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:24:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10159 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab3GRRYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:24:24 -0400
X-IronPort-AV: E=Sophos;i="4.89,695,1367971200"; 
   d="scan'208";a="37864286"
Date: Thu, 18 Jul 2013 18:24:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabledo
In-Reply-To: <20130718165007.GA24642@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1307181755371.8258@kaball.uk.xensource.com>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com> <20130717151148.GM24642@n2100.arm.linux.org.uk> <51E81B39.2030805@linaro.org>
 <20130718165007.GA24642@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Russell King - ARM Linux wrote:
> On Thu, Jul 18, 2013 at 05:43:37PM +0100, Julien Grall wrote:
> > When Xen will boot, it will use one UART, given by the user, to be able
> > to log its information. Xen will not map the UART region and the IRQ to
> > dom0. Of course it will not be present in the device tree either. So if
> > Linux tries to access to this memory region, it will crash.
> > 
> > When Linux will boot as dom0, it will either use an hvc console or
> > another UART.
> > 
> > In case of multi-platform environments, there is no issue because when
> > CONFIG_DEBUG_UNCOMPRESS is disabled.
> > 
> > Now, in non-multiplatform environment, the decompressor will use a
> > pre-defined UART. This UART may be already used by Xen and Linux will
> > abort at the first access.
> > 
> > I think, the decompressor should be able to detect if the UART exists
> > (I'm not sure it's possible) or disabled at compile time uncompress log.
> > 
> > Do you have any better ideas?
> 
> Let me get this straight.
> 
> 1. You want to run an _existing_ platforms kernel under Xen, where the
>    platform assumes that it has various devices at various locations,
>    and will make direct accesses to those devices.
> 
> 2. You don't want to provide some of those devices, and you arrange for
>    those unprovided devices to fault.
> 
> Excuse me if I think that's really silly.

Unfortunately not all the platforms are available on multiplatform
kernels.
Also by the same argument, we wouldn't need device tree on
non-multiplatform kernels because we could hardcode almost anything.


> Lastly, aren't all ARMv7 kernels (therefore Xen supporting kernels)
> supposed to be part of the multiplatform kernel stuff now?

Most of them, yes. However some of them, like exynos5250, are not yet.
