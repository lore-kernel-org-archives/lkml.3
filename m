Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaDRMrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:47:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40057 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754322AbaDRMrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:37 -0400
Date: Fri, 18 Apr 2014 13:46:52 +0100
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
Message-ID: <20140418124652.GE24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5351145D.8070207@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 02:02:37PM +0200, Andrzej Hajda wrote:
> Separation of the interfaces exposed by the device from the device itself
> seems to me a good thing. I would even consider it as a biggest
> advantage of this solution :)
> 
> The problem of re-initialization does not seems to be relevant here, it
> is classic
> problem of coding correctness nothing more, it can appear here and in
> many different
> places.

It may be a problem of coding correctless, but it's also a maintainability
problem too - it makes it _much_ more difficult to ensure that everything
is correct.

> Anyway it seems we have different point of view on the problem, your say
> about devices with two stage initialization. I see it more as devices
> registering interfaces and superdevice using it.

Right, so please make this exynos-specific, because from what I can see it
has no reason to pretend to be generic.  As I've already pointed out, it
can't be used in the general case because it ties sub-components directly
to their main driver, which is absolutely absurd.  Please keep this
absurdness in exynos and don't spread it around.  Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
