Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaIWNuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:50:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57829 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753595AbaIWNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:50:12 -0400
Date: Tue, 23 Sep 2014 15:50:07 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 7/9] net: pxa168_eth: allow Berlin SoCs to use the
 pxa168_eth driver
Message-ID: <20140923135007.GB18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411474536-22626-8-git-send-email-antoine.tenart@free-electrons.com>
 <4458671.9hKSvmlZNz@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4458671.9hKSvmlZNz@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tue, Sep 23, 2014 at 02:40:01PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 14:15:34 Antoine Tenart wrote:
> > diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> > index 1b4fc7c639e6..48b9466d1781 100644
> > --- a/drivers/net/ethernet/marvell/Kconfig
> > +++ b/drivers/net/ethernet/marvell/Kconfig
> > @@ -64,7 +64,7 @@ config MVPP2
> >  
> >  config PXA168_ETH
> >         tristate "Marvell pxa168 ethernet support"
> > -       depends on CPU_PXA168
> > +       depends on CPU_PXA168 || ARCH_BERLIN
> >         select PHYLIB
> >         ---help---
> >           This driver supports the pxa168 Ethernet ports.
> > 
> 
> Myabe you can also add '|| COMPILE_TEST' here, to allow building it

We can add this.

> on other architectures. Check if you need 'depends on OF' though.

I don't think that's needed, the driver still supports non-dt cases.
I'll check.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
