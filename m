Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaDQVsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:48:08 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39007 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750874AbaDQVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:47:58 -0400
Date: Thu, 17 Apr 2014 22:47:09 +0100
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
Message-ID: <20140417214709.GY24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:28:50PM +0200, Andrzej Hajda wrote:
> +out:
> +	if (ret != -EPROBE_DEFER)
> +		exynos_drm_dev_ready(&pdev->dev);

So we end up with everyone needing a "ready" call in each sub-driver
back into the main driver... this makes it impossible to write a
generic subcomponent driver which is not tied in any way to the
main driver.

That is quite some restriction, and would prevent, for example, the
TDA998x driver being used both with Armada DRM, tilcdc and any other
driver.

So, while your solution may work for exynos, it's not suitable for
general use.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
