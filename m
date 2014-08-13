Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaHMKon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:44:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48996 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbaHMKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:44:40 -0400
Date: Wed, 13 Aug 2014 11:44:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] cpuidle/cpuidle-big_little: fix reading cpu id part
	number
Message-ID: <20140813104431.GJ30401@n2100.arm.linux.org.uk>
References: <1407501757-15231-1-git-send-email-juri.lelli@arm.com> <20140808132105.GB30282@n2100.arm.linux.org.uk> <20140808164737.GB11623@e102568-lin.cambridge.arm.com> <53EB381D.7080604@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB381D.7080604@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:04:13AM +0100, Juri Lelli wrote:
> Thanks a lot for the comment. Does what below address it?

Yes, thanks, but a few of nitpicks though.

> +/*
> + * smp_cpuid_part() - return part id for a given cpu
> + *
> + * @cpu: logical cpu id
> + *
> + * Return: part id of logical cpu passed as argument
> + *
> + */

If this is supposed to be a kerneldoc-compatible comment, please read
Documentation/kernel-doc-nano-HOWTO.txt for the correct format.

> +static inline unsigned int smp_cpuid_part(int cpu)
> +{
> +	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpu);
> +
> +	return is_smp() ? (cpu_info->cpuid  & ARM_CPU_PART_MASK) :

Parens are not required, and there's a double space before &.

The BNF for the ?: operator is:

cond-expr:
	log-or-expr ? expr : cond-expr

So the compiler knows that whatever is between the ? and : is a single
expression, and the parens are surplus.

> -static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
> +static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int match_id)

If we're changing the name, "part_id" would probably be better than the
opaque "match_id" here.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
