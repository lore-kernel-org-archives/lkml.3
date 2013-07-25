Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3GYLGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:06:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3GYLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:06:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Thu, 25 Jul 2013 13:00:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, broonie@kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org> <201307242032.03597.arnd@arndb.de> <2174304.5JlzJ583hP@avalon>
In-Reply-To: <2174304.5JlzJ583hP@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251300.49282.arnd@arndb.de>
X-Provags-ID: V02:K0:orxXnsGNKQ+pfLXUig7PxrgtallJK+GVjzCJq3ZJSB+
 b1R86yLJTf9t6AqIHJa0fG0amOipv3YlgSozoE3uIL5jQ2/sZZ
 Vuh9AgLWMIGisDi6Rt/V0DURUxRDs2i+dQHZaVdzSIUUSXgWcy
 cbt6I1JWcdoc+PzeBeFLyrBLLa91MZSeR5gEEEcv/wntwO6/fA
 1U1X6aodcu9eCLuMkBXM0IDta80pcxgpWPG+oE18OUc2cHLhPX
 2fjJ8g7kqr/lzI3JNf110gs0if3QSgBB6FQXwXPS5EQ7av9iO5
 zmZ2VcoT5oVJ2oxeZdnf8jJsezbs8pinNDdfsxn0n1Rk1Qhrhh
 gQW84diCOiRUsPMyMvkA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 July 2013, Laurent Pinchart wrote:
> On Wednesday 24 July 2013 20:32:03 Arnd Bergmann wrote:
> > On Tuesday 23 July 2013, Tomasz Figa wrote:
> > > On Tuesday 23 of July 2013 17:14:20 Alan Stern wrote:
> > > > On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > > > > Where would you want to have those phy_address arrays stored? There
> > > > > are no board files when booting with DT. Not even saying that you
> > > > > don't need to use any hacky schemes like this when you have DT that
> > > > > nicely specifies relations between devices.
> > > > 
> > > > If everybody agrees DT has a nice scheme for specifying relations
> > > > between devices, why not use that same scheme in the PHY core?
> > > 
> > > It is already used, for cases when consumer device has a DT node attached.
> > > In non-DT case this kind lookup translates loosely to something that is
> > > being done in regulator framework - you can't bind devices by pointers,
> > > because you don't have those pointers, so you need to use device names.
> > 
> > Sorry for jumping in to the middle of the discussion, but why does a new
> > framework even bother defining an interface for board files?
> > 
> > Can't we just drop any interfaces for platform data passing in the phy
> > framework and put the burden of adding those to anyone who actually needs
> > them? All the platforms we are concerned with here (exynos and omap, plus
> > new platforms) can be booted using DT anyway.
> 
> What about non-DT architectures such as MIPS (still widely used in consumer 
> networking equipments from what I've heard) ?

* Vendors of such equipment have started moving on to ARM (e.g. Broadcom bcm47xx)
* Some of the modern MIPS platforms are now using DT
* Legacy platforms probably won't migrate to either DT or the generic PHY framework

I'm not saying that we can't support legacy board files with the common
PHY framework, but I'd expect things to be much easier if we focus on those
platforms that are actively being worked on for now, to bring an end to the
pointless API discussion.

	Arnd
