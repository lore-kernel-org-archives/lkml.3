Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaIWOe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:34:26 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53351 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaIWOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:34:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 23 Sep 2014 16:33:48 +0200
Message-ID: <3708177.kEGF9Dk44n@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923140113.GC18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com> <51745791.Wuu5QiQB2e@wuerfel> <20140923140113.GC18924@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5ix4XDrNM1RZbY1TWXI+4ROL9gwX7niXPxfp2LVUkoQ
 +WmsddD2bhDrUlrxw0RkIzEnDazr0d4WeEFb5PKbQxPkqsyvLp
 lRPt0hfD6/6fn/kw/ESMWGPkgBzqlql4f7wNdxZnz3m3O5VceW
 7tpVgKdHlvTIQwhAHZMJ3XuA4c+/rggxx4nO8Lx1pi6z+zCuA7
 PhzFKacDco4xvd0+VphBzragk41HjH/GYINjb/N1scJyi90DFf
 PXEklNYvzC0pxczCSLYW7vsml9s6RyOv/5/RT9lWBpr4XK5SDN
 c0/yxgx9UElVSuV0Kty4BdOp0yjNrydeHsHJS1kimMDbyeJbOI
 tQGxzF4vrwI605mRdQBg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 16:01:13 Antoine Tenart wrote:
> 
> On Tue, Sep 23, 2014 at 02:38:39PM +0200, Arnd Bergmann wrote:
> > On Tuesday 23 September 2014 14:15:30 Antoine Tenart wrote:
> > > +Optional properties:
> > > +- port-id: should be '0','1' or '2'.
> > > +- phy-addr: MDIO address of the PHY.
> > > +- local-mac-address: see ethernet.txt file in the same directory.
> > > +
> > > 
> > 
> > I believe new bindings should not use "phy-addr" properties, but
> > instead use a phy-handle property pointing to a phy device instead.
> 
> That's the MDIO address of the PHY. It's a bit difficult to use a phy
> device as the driver uses the libphy. And that would break the platform
> using it.
> 
> Or maybe you have something in mind?

I don't understand what you mean. Doesn't libphy imply using a phy_device?
What I meant was that you should be able to just call the standard
of_phy_connect() and other interfaces to deal with phylib.

	Arnd
