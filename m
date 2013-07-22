Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3GVMr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:47:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab3GVMr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:47:56 -0400
Date: Mon, 22 Jul 2013 14:47:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC -v2 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130722124754.GC24400@dhcp22.suse.cz>
References: <1374224699-13255-2-git-send-email-mhocko@suse.cz>
 <1374493502-31907-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374493502-31907-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-07-13 13:45:02, Michal Hocko wrote:
[...]
> @@ -486,7 +486,50 @@ static struct smp_hotplug_thread watchdog_threads = {
>  	.unpark			= watchdog_enable,
>  };
>  
> -static int watchdog_enable_all_cpus(void)
> +static void restart_watchdog_hrtimer(void *info)
> +{
> +	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> +
> +	hrtimer_restart(hrtimer);

Ohh, scratch that. This is not sufficient because the the new sampling
period is not considered. I will repost updated version soon

-- 
Michal Hocko
SUSE Labs
