Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaB0WSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:18:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59745 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaB0WSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:18:20 -0500
Date: Thu, 27 Feb 2014 23:18:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140227221819.GA6910@amd.pavel.ucw.cz>
References: <1393372920-3896-1-git-send-email-sebastian.capella@linaro.org>
 <1393372920-3896-4-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393372920-3896-4-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Tue 2014-02-25 16:02:00, Sebastian Capella wrote:
> From: Russ Dill <Russ.Dill@ti.com>
> 
> Enable hibernation for ARM architectures and provide ARM
> architecture specific calls used during hibernation.
> 
> The swsusp hibernation framework depends on the
> platform first having functional suspend/resume.
> 
> Then, in order to enable hibernation on a given platform, a
> platform_hibernation_ops structure may need to be registered with
> the system in order to save/restore any SoC-specific / cpu specific
> state needing (re)init over a suspend-to-disk/resume-from-disk cycle.
> 
> For example:
> 
>      - "secure" SoCs that have different sets of control registers
>        and/or different CR reg access patterns.
> 
>      - SoCs with L2 caches as the activation sequence there is
>        SoC-dependent; a full off-on cycle for L2 is not done
>        by the hibernation support code.
> 
>      - SoCs requiring steps on wakeup _before_ the "generic" parts
>        done by cpu_suspend / cpu_resume can work correctly.
> 
>      - SoCs having persistent state which is maintained during suspend
>        and resume, but will be lost during the power off cycle after
>        suspend-to-disk.
> 
> This is a rebase/rework of Frank Hofmann's v5 hibernation patchset.
> 

> +/*
> + * Snapshot kernel memory and reset the system.
> + * soft_restart is not technically needed, but is used
> + * to get success returned from cpu_suspend.
> + * After resume, the hibernation snapshot is written out.
> + */
> +static int notrace __swsusp_arch_save_image(unsigned long unused)
> +{
> +	int ret;
> +
> +	ret = swsusp_save();
> +	if (ret == 0)
> +		soft_restart(virt_to_phys(cpu_resume));
> +	return ret;
> +}

This is static, so maybe arch_save_image() is better name?

> +static u8 __swsusp_resume_stk[PAGE_SIZE/2] __nosavedata;

resume_stack?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
