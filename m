Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666AbaH0S1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:27:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40910 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935020AbaH0S1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:27:42 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 4/7] ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
Organization: Deep Root Systems, LLC
References: <1408715373-25791-1-git-send-email-nm@ti.com>
	<1408715373-25791-5-git-send-email-nm@ti.com>
Date: Wed, 27 Aug 2014 11:27:38 -0700
In-Reply-To: <1408715373-25791-5-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Fri, 22 Aug 2014 08:49:30 -0500")
Message-ID: <7h1ts1eqjp.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> powerdomain configuration in OMAP is done using PWRSTCTRL register for
> each power domain. However, PRCM lets us write any value we'd like to
> the logic and power domain target states, however the SoC integration
> tends to actually function only at a few discrete states. These valid
> states are already in our powerdomains_xxx_data.c file.
>
> So, provide a function to easily query valid low power state that the
> power domain is allowed to go to.
>
> Based on work originally done by Jean Pihet <j-pihet@ti.com>
> https://patchwork.kernel.org/patch/1325091/ . There is no attempt to
> create a new powerdomain solution here, except fixing issues seen
> attempting invalid programming attempts. Future consolidation to the
> generic powerdomain framework should consider this requirement as
> well.
>
> Similar solutions have been done in product kernels in the past such
> as:
> https://android.googlesource.com/kernel/omap.git/+blame/android-omap-panda-3.0/arch/arm/mach-omap2/pm44xx.c
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---

nit: this is part of a fixes series, but it's more of a new feature.

That being said, the feature is needed and looks OK, except for...

> +up_search:
> +	/* OK, no deeper ones, can we get a higher match? */
> +	new_pwrst = req_state + 1;
> +	while (!(pwrdm_states & BIT(new_pwrst))) {
> +		/* BUG if we have messed up database */
> +		BUG_ON(new_pwrst > PWRDM_POWER_ON);

I don't think this is BUG() worthy, and should have a saner way to recover.

Kevin
