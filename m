Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaIYTzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:55:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875AbaIYTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:54:58 -0400
Date: Thu, 25 Sep 2014 21:54:54 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140925195454.GA6074@kwain>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <201409252112.07513.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409252112.07513.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, Sep 25, 2014 at 09:12:07PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014, Antoine Tenart wrote:
> > +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> > +                                struct ci_hdrc_platform_data *ci_pdata)
> > +{
> > +       ci_pdata->phy = of_phy_get(dev->of_node, 0);
> 
> FWIW, I accidentally built a kernel with this driver enabled and got a warning
> for this code. The problem is that ci_pdata->phy is a 'struct usb_phy' pointer,
> while of_phy_get() returns a generic 'struct phy'. While the two have similar
> behavior, they are not the same thing and this can't work.

That's because this series applies on top of:
https://lkml.org/lkml/2014/9/15/141

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
