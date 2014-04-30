Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946073AbaD3W3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:29:44 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59459 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933759AbaD3W3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:29:43 -0400
Date: Wed, 30 Apr 2014 23:28:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <andrzej.hajda@wp.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 0/4] drivers/base: Generic framework for tracking
	internal interfaces
Message-ID: <20140430222839.GE26756@n2100.arm.linux.org.uk>
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com> <20140430154914.GA898@kroah.com> <53616E31.3050404@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53616E31.3050404@wp.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:42:09PM +0200, Andrzej Hajda wrote:
> The main problem with component framework is that componentization  
> significantly changes every driver and changes it in a way which is not  
> compatible with traditional drivers, so devices which are intended to  
> work with different DRM masters are hard to componentize if some of DRMs  
> are componentized and some not.

Many of the problems which the component helpers are designed to solve
are those where you need the drm_device structure (or snd_card, or whatever
subsystem specific card/device representation structure) pre-created in
order to initialise the components.

In the case of DRM, you can't initialise encoders or connectors without
their drm_device structure pre-existing - because these components are
attached to the drm_device.

Your solution to that is to delay those calls, but the DRM subsystem is
not designed to cope like that - it's designed such that when the
connector or encoder initialisation functions are called, it is assumed
that the driver is initialising its state. (I've raised this point before
but you've just fobbed it off in the past.)

Another issue here is that the order of initialisation matters greatly.
Take CRTCs for example.  In DRM, the order of attachment of CRTCs defines
their identity, changing the order changes their identity, and changes
how they are bound to their respective connectors.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
