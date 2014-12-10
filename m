Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaLJRji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:39:38 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50049 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932261AbaLJRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:39:36 -0500
Date: Wed, 10 Dec 2014 17:39:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: A H <andrzej.hajda@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 00/15] Resource tracking/allocation framework
Message-ID: <20141210173918.GN11285@n2100.arm.linux.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <20141210161620.GM11285@n2100.arm.linux.org.uk>
 <CA+tnuKYSDZ0mtzQ_g1QjovJwG01OgPjSXuozEBXQsEZv_2o-=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+tnuKYSDZ0mtzQ_g1QjovJwG01OgPjSXuozEBXQsEZv_2o-=w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 06:23:49PM +0100, A H wrote:
> 10 gru 2014 17:16 "Russell King - ARM Linux" <linux@arm.linux.org.uk>
> napisał(a):
> >
> > On Wed, Dec 10, 2014 at 04:48:18PM +0100, Andrzej Hajda wrote:
> > > 3. There are drivers which can work without specific resource, but if
> > >   the resource becomes available/unavailable it can do some additional
> stuff.
> > >   An example of such driver is DRM driver (more precisely
> drm_connector) -
> > >   it can start without attached drm_panel, but if the panel becomes
> available it
> > >   can react by generating HPD event and start using it.
> >
> > Bad example, and actually incorrect.  DRM connectors are referenced in
> > userspace by an IDR number, which can be re-used in the case of a
> > connector appearing, disappearing, and then a different connector
> > re-appearing.
> 
> But it is not about reappearing of drm_connector, it is about reappearing
> of drm_panel which is fortunately not a part of drm driver. Connector here
> is only consumer of drm_panel which should have possibility to receive
> notifications on panel (dis-)appearance.

Okay, so that's exactly like a panel being "hotplugged" to the connector,
which should be fine.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
