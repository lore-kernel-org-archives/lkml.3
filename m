Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935699AbaH0SbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:31:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33094 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935181AbaH0Sa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:30:58 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 0/7] ARM: OMAP4+: powerdomain fixes
Organization: Deep Root Systems, LLC
References: <1408715373-25791-1-git-send-email-nm@ti.com>
Date: Wed, 27 Aug 2014 11:30:55 -0700
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Fri, 22 Aug 2014 08:49:26 -0500")
Message-ID: <7hwq9tdbts.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> The following series are various fixes and improvements for
> powerdomain support in OMAP4+.

Ah, here I see "fixes and improvements" since I was about to nipick that
the series contains more than just fixes.

Anyways, the series looks good to me.  After fixing up the BUG_ON issue,
feel free to add

Reviewed-by: Kevin Hilman <khilman@linaro.org>

> This is part 1/6 series which eventually enables framework for
> suspend-to-ram and cpuidle for OMAP5 and DRA7
>
> Each of series is based on v3.17-rc1 and this specific series is available:
> weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/powerdomain-fixes
>
> git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/powerdomain-fixes
>
> An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
>
> Nishanth Menon (7):
>   ARM: OMAP: DRA7: powerdomain data: fix powerdomain powerstate
>   ARM: OMAP5: powerdomain data: fix powerdomain powerstate
>   ARM: OMAP2+: powerdomain: pwrdm_for_each_clkdm iterate only valid
>     clkdms
>   ARM: OMAP2+: powerdomain: introduce logic for finding valid power
>     domain
>   ARM: OMAP4+: PM: Make logic state programmable
>   ARM: OMAP4+: PM: use only valid low power state for suspend
>   ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug
>
>  arch/arm/mach-omap2/omap-mpuss-lowpower.c   |    4 ++
>  arch/arm/mach-omap2/pm44xx.c                |    9 +++-
>  arch/arm/mach-omap2/powerdomain.c           |   76 ++++++++++++++++++++++++++-
>  arch/arm/mach-omap2/powerdomain.h           |    4 ++
>  arch/arm/mach-omap2/powerdomains54xx_data.c |   12 ++---
>  arch/arm/mach-omap2/powerdomains7xx_data.c  |   14 ++---
>  6 files changed, 103 insertions(+), 16 deletions(-)
