Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3KLUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:23:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40101 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KLUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:23:22 -0500
Message-ID: <52828E31.8010408@wwwdotorg.org>
Date: Tue, 12 Nov 2013 13:23:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 4/7] ARM: tegra: add support for Trusted Foundations
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com> <1383819106-1400-5-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1383819106-1400-5-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
> Register the firmware operations for Trusted Foundations if the device
> tree indicates it is active on the device.

> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c

>  void __init tegra_init_early(void)
>  {
> +	of_register_trusted_foundations();
>  	tegra_cpu_reset_handler_init();
>  	tegra_apb_io_init();
>  	tegra_init_fuse();

Your other bugfix patch for 3.13 moved tegra_cpu_reset_handler_init().
Should the call to of_register_trusted_foundations() move with it when
this is applied, or should it just stay right at the start of
tegra_init_early()? Either way is fine; just let me know which way to
fix up the conflict when this gets applied.
