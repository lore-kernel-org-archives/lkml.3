Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaJIIxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:53:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58319 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918AbaJIIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:53:14 -0400
Date: Thu, 9 Oct 2014 09:52:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Thierry Reding <treding@nvidia.com>, linux-samsung-soc@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
Message-ID: <20141009085258.GI5182@n2100.arm.linux.org.uk>
References: <542B9A0E.7020206@samsung.com> <1412151287-12845-1-git-send-email-a.hajda@samsung.com> <542D13CC.5000304@samsung.com> <542D2E7C.1020904@samsung.com> <542D3C96.7000400@samsung.com> <54362066.9000504@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54362066.9000504@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 02:43:02PM +0900, Alexandre Courbot wrote:
> But there might be another issue, which is that calls to  
> drm_vblank_get() will return -EINVAL if invoked between drm_blank_off  
> and drm_blank_on. Is this really the desired behavior? Can it at least  
> happen? If so, how are drivers supposed to react to this situation?

I've not yet seen the commit which causes this problem, but I hope
that drm_wait_vblank() isn't affected by this.  In current mainline,
drm_vblank_get() is used inside drm_wait_vblank(), which is called as
a result of userspace calling DRM_IOCTL_WAIT_VBLANK.

So, what is the effect of this change on user applications making use
of the vblank wait ioctl - and is that change intended?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
