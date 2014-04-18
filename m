Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaDRMnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:43:09 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40047 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751869AbaDRMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:42:53 -0400
Date: Fri, 18 Apr 2014 13:42:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for
	components tracking
Message-ID: <20140418124202.GD24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417214709.GY24070@n2100.arm.linux.org.uk> <53510C39.1020205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53510C39.1020205@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:27:53PM +0200, Andrzej Hajda wrote:
> Hi Russel,
> 
> Thanks for comments.
> 
> On 04/17/2014 11:47 PM, Russell King - ARM Linux wrote:
> > On Thu, Apr 17, 2014 at 01:28:50PM +0200, Andrzej Hajda wrote:
> >> +out:
> >> +	if (ret != -EPROBE_DEFER)
> >> +		exynos_drm_dev_ready(&pdev->dev);
> > So we end up with everyone needing a "ready" call in each sub-driver
> > back into the main driver... this makes it impossible to write a
> > generic subcomponent driver which is not tied in any way to the
> > main driver.
> >
> > That is quite some restriction, and would prevent, for example, the
> > TDA998x driver being used both with Armada DRM, tilcdc and any other
> > driver.
> 
> As I see in armada driver drm is deferred in case tda998x is not yet
> available. The same solution can be still used with pending_devices
> approach - the main driver will not report its readiness until tda998x
> is present.
> 
> Anyway it still seems to be better than componentize every driver which can
> probably become a part of some superdevice.
> 
> If you want to get rid of deferred probe one can make global list of
> 'ready' devices with notifications systems for master devices.
> 
> Maybe it would be good to consider notification system for devices probe
> result,
> it will require that driver register all its interfaces in probe, ie its
> readiness cannot
> be reported later but will not require to add new framework. I hope just
> extending current
> notification system should be enough.

You aren't addressing my point.  If I were to convert tda998x to use
your infrastructure, then I would have to add in ifdefs to tie it into
armada DRM _and_ a different set of ifdefs to tie it into tilcdc.  Then
when someone else wanted to use it in their driver, they'd have to add
yet more ifdefs into it to tie it into their driver.

This does not scale.

So, please address my point: in your system, how can a single component
be shared between multiple different master drivers?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
