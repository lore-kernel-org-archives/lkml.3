Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3FMTXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:23:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41084 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab3FMTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:23:45 -0400
Message-ID: <51BA1C3D.1010608@wwwdotorg.org>
Date: Thu, 13 Jun 2013 13:23:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Joseph Lo <josephl@nvidia.com>, Karan Jhavar <kjhavar@nvidia.com>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/3] ARM: tegra: set CPU reset handler with firmware
 op
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com> <1371114745-24710-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1371114745-24710-4-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
> Use a firmware operation to set the CPU reset handler and only resort to
> doing it ourselves if there is none defined.
> 
> This supports the booting of secondary CPUs on devices using a TrustZone
> secure monitor.

> diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c

> +	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
> +	switch (err) {
> +	case -ENOSYS:
> +		tegra_cpu_reset_handler_set(reset_address);
> +		/* pass-through */

Rather than detecting -ENOSYS and falling back to the custom
tegra_cpu_reset_handler_set(), does it make sense to plug in
tegra_cpu_reset_handler_set as the firmware op when there is no secure
firmware detected? That way, this code wouldn't need the special case;
that would be isolated to firmware.c.
