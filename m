Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3GYHyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:54:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:54:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Thu, 25 Jul 2013 09:54:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
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
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org> <201307242032.03597.arnd@arndb.de> <51F0B373.5050907@ti.com>
In-Reply-To: <51F0B373.5050907@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307250954.27190.arnd@arndb.de>
X-Provags-ID: V02:K0:a4rQXnMrmdZbOxZwfy0RAcTJGO4DaW2nhDFh/75vYHC
 AL0pSSk8zjn8xiPlkkkz1M7nLaZtltDA4ig5HbMSFdXmKndkSr
 opm8WBF3GvoCoz30XqIYdOXmldb4nROmFs43Ubtn/+Z9fQsNQ0
 NIE22+X8fcheb0CGA0ARL/sZGt/o62jBVmMPmEHvBTKVLEtgJj
 hPCZEAL6faMk29Tw/JzyPDP/GFpv3WLFLT7TUSAOwYD+frM+IR
 b/wUarBw84Uf21NvMHeupnsVcC9c6qxvZi7+LWEp53bHhRhs1q
 RFiitCLS1gYr7Cl/qexEKorQlm/C5xuomRDc6jJAOTYy3PgSDN
 Fm9DlZbmutNO97RyRLgw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 July 2013, Kishon Vijay Abraham I wrote:
> On Thursday 25 July 2013 12:02 AM, Arnd Bergmann wrote:
> > On Tuesday 23 July 2013, Tomasz Figa wrote:
> >> On Tuesday 23 of July 2013 17:14:20 Alan Stern wrote:
> >>> On Tue, 23 Jul 2013, Tomasz Figa wrote:
> >>>> Where would you want to have those phy_address arrays stored? There
> >>>> are no board files when booting with DT. Not even saying that you
> >>>> don't need to use any hacky schemes like this when you have DT that
> >>>> nicely specifies relations between devices.
> >>>
> >>> If everybody agrees DT has a nice scheme for specifying relations
> >>> between devices, why not use that same scheme in the PHY core?
> >>
> >> It is already used, for cases when consumer device has a DT node attached. 
> >> In non-DT case this kind lookup translates loosely to something that is 
> >> being done in regulator framework - you can't bind devices by pointers, 
> >> because you don't have those pointers, so you need to use device names.
> >>
> > 
> > Sorry for jumping in to the middle of the discussion, but why does a new
> > framework even bother defining an interface for board files?
> > 
> > Can't we just drop any interfaces for platform data passing in the phy
> > framework and put the burden of adding those to anyone who actually needs
> > them? All the platforms we are concerned with here (exynos and omap,
> > plus new platforms) can be booted using DT anyway.
> 
> The OMAP3 platforms still needs to be supported for non-dt :-s

Can't you leave the existing PHY handling for legacy OMAP3 USB PHY
until they are all converted? I don't expect that to take a long time
now that the OMAP4 board files have been removed. Are there still
drivers without DT bindings that hold up the removal of the OMAP3
board files?

Otherwise I'd suggest delaying the phy subsystem by another merge window,
until that is resolved.

	Arnd
