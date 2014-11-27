Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaK0JQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:16:27 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45914 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaK0JOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:14:52 -0500
Date: Thu, 27 Nov 2014 01:14:48 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Message-ID: <20141127091448.GU3212@norris-Latitude-E6410>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <20141126211240.GD21347@ld-irv-0074>
 <A765B125120D1346A63912DDE6D8B6315EE059@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EE059@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:55:43AM +0000, bpqw wrote:
 
> >What's the difference between using EVCR and the ENTER QUAD I/O MODE
> >(35h) command I see in some of your datasheets? Are both supported on all Micron quad I/O SPI NOR flash?
> 
> There is no difference between using EVCR and the ENTER QUAD I/O MODE command.
> But, for some Micron spi nor, there no ENTER Quad I/O command(35h),such as n25q064.
> for all current Micron spi nor, if it support quad I/O mode, Using EVCR definitely be supported.
> So, we recommend that enable QUAD I/O mode by writing ECVR.

Good to know. Thanks for the info. Maybe you can note this somewhere in
your next version, like a comment in the commit description.

> >Also, which SPI NOR is this enabled for? I don't see any Micron entries in spi_nor_ids[] which contain the SPI_NOR_QUAD_READ flag.
> 
> Yes, we now don't see any Micron entries in spi_nor_ids[] which
> contain the SPI_NOR_QUAD_READ flag. But Micron spi nor in
> spi_nor_ids[] all support Quad I/O mode.

Then add them! At least, for flash that support them (for all packages
that might share the same ID).

> maybe customer want to use default mode(extended I/O mode),
> When submitted relevant patch, they didn't SPI_NOR_QUAD_READ flag in the spi_nor_ids[].

The flag may have been omitted because it didn't exist at the time. Or
it didn't get tested.

Regardless, just because you enable this flag in spi_nor_ids[] doesn't
mean that it will enable Quad I/O for users that can't support it; board
files / DT descriptions still have to opt in by advertising hardware
support for Quad I/O.

See, for example, spi-tx-bus-width and spi-rx-bus-width properties in
Documentation/devicetree/bindings/spi/spi-bus.txt.

> This patch is just for wanting to enable Micron Quad I/O mode.

That's fine. But I'd welcome any follow-up patch to add the QUAD flag to
the right Micron table entries. Otherwise, this patch doesn't actually
help anyone.

BTW, given that you aren't changing any entries to spi_nor_ids[] yet,
have you actually tested this patch? Or are you only working off the
specifications / datasheets?

Thanks,
Brian
