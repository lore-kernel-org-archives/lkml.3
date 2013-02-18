Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3BRBFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:05:54 -0500
Received: from mail-ye0-f179.google.com ([209.85.213.179]:45756 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3BRBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:05:53 -0500
Date: Sun, 17 Feb 2013 17:02:07 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM: sa1100: collie-battery.c: include platform_device.h
 directly
Message-ID: <20130218010207.GA31969@lizard.gateway.2wire.net>
References: <1361038560-3690-1-git-send-email-andrea.adami@gmail.com>
 <20130216230010.GG1741@lizard.sbx05280.losalca.wayport.net>
 <CAAQYJAt0CGi3ZLO8eoYj64Ay06Yry_w8A6aPHHH1tpeyp=Ns4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAQYJAt0CGi3ZLO8eoYj64Ay06Yry_w8A6aPHHH1tpeyp=Ns4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 01:13:46AM +0100, Andrea Adami wrote:
> On Sun, Feb 17, 2013 at 12:00 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> > Hi Andrea,
> >
> > On Sat, Feb 16, 2013 at 07:16:00PM +0100, Andrea Adami wrote:
> >> Initial try to fix compilation error
> >
> > Things are a bit more complex...
> >
> >> linux/include/linux/mfd/mcp.h:22:16: error: field 'attached_device' has incomplete type
> >
> > You have to add #include <linux/device.h> into mfd/mcp.h. This will add
> > struct device and...
> >
> Bingo.Adding it solves all following errors, no need for further inclusions.
> 
> >> linux/include/linux/mfd/mcp.h:48:23: error: field 'drv' has incomplete type
> >
> > struct device_driver.
> >
> >> linux/include/linux/mfd/ucb1x00.h:137:17: error: field 'dev' has incomplete type
> >
> > Same here, the file ucb1x00.h needs #include <linux/device.h>.
> >
> Seems not needed, mcp.h is included by ucb1x00.h

Generally, we don't depend on indirect inclusions. But if it doesn't harm
anyhow so far, we may not bother with this.

Thanks,

Anton
