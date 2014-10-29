Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaJ2Rqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:46:38 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33411 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbaJ2Rqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:33 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
	<1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 29 Oct 2014 10:46:29 -0700
In-Reply-To: <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
	(Krzysztof Kozlowski's message of "Thu, 23 Oct 2014 15:48:09 +0200")
Message-ID: <7hk33iahvu.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:

> When resuming the system the power domain has to be powered on early so
> any runtime PM aware devices could resume.
>
> This fixes following scenario reproduced on Exynos DRM:
> 1. Power domain is off before suspending the system.
> 2. System is suspended to RAM.
> 3. Resuming starts. The Exynos DRM driver resume callback is called.
> 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
>    the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.

Dumb Q: if the device (and power domain) were off before (and during)
suspend, why are they being resumed?

Shouldn't the resume path restore things to the same state they were
before suspend?

Kevin
