Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaLJQQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:16:39 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49900 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751330AbaLJQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:16:37 -0500
Date: Wed, 10 Dec 2014 16:16:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        boris.brezillon@free-electrons.com
Subject: Re: [RFC 00/15] Resource tracking/allocation framework
Message-ID: <20141210161620.GM11285@n2100.arm.linux.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 04:48:18PM +0100, Andrzej Hajda wrote:
> 3. There are drivers which can work without specific resource, but if
>   the resource becomes available/unavailable it can do some additional stuff.
>   An example of such driver is DRM driver (more precisely drm_connector) -
>   it can start without attached drm_panel, but if the panel becomes available it
>   can react by generating HPD event and start using it.

Bad example, and actually incorrect.  DRM connectors are referenced in
userspace by an IDR number, which can be re-used in the case of a
connector appearing, disappearing, and then a different connector
re-appearing.

DRM really is *not* safe to hotplug like this: DRM is more a card-level
thing, which is why we have the component helpers - which allow us to
merge several devices into one logical card-like device in a generic
manner.

DRM needs a stable picture of the CRTCs, encoders and connectors, which
should _never_ change during the lifetime of the DRM device.  Devices
attached to connectors can be hotplugged, but that's about the limit of
hot-plugging in DRM.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
