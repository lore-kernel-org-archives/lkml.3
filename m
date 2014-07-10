Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaGJODr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:03:47 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:45516 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaGJODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:03:45 -0400
Date: Thu, 10 Jul 2014 15:58:59 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Quentin Armitage <quentin@armitage.org.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] cpufreq: kirkwood: Reinstate cpufreq driver for
 ARCH_KIRKWOOD
Message-ID: <20140710135859.GL21833@lunn.ch>
References: <1404987355.23201.65.camel@samson1.armitage.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404987355.23201.65.camel@samson1.armitage.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:15:55AM +0100, Quentin Armitage wrote:
> Commit ff1f0018cf66080d8e6f59791e552615648a033a ("drivers: Enable
> building of Kirkwood drivers for mach-mvebu") added Kirkwood into
> mach-mvebu, adding MACH_KIRKWOOD to ARCH_KIRKWOOD in the KConfig files.
> 
> The change for ARM_KIRKWOOD_CPUFREQ replaced ARCH_KIRKWOOD with
> MACH_KIRKWOOD, whereas all the other changes were ARCH_KIRKWOOD ||
> MACH_KIRKWOOD.
> 
> As a consequence of this change, the cpufreq driver is no longer enabled
> for ARCH_KIRKWOOD. This patch reinstates ARM_KIRKWOOD_CPUFREQ for
> ARCH_KIRKWOOD.
> 
> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> ---
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ebac671..24778f0 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -118,7 +118,7 @@ config ARM_INTEGRATOR
>           If in doubt, say Y.
> 
>  config ARM_KIRKWOOD_CPUFREQ
> -       def_bool MACH_KIRKWOOD
> +       def_bool ARCH_KIRKWOOD || MACH_KIRKWOOD
>         help
>           This adds the CPUFreq driver for Marvell Kirkwood
>           SoCs.

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew  
