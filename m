Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaFQI7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:59:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaFQI7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:59:44 -0400
Date: Tue, 17 Jun 2014 10:59:43 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Wu <peter@lekensteyn.nl>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: Writing watchdog_thresh triggers BUG: sleeping function called
 from invalid context
Message-ID: <20140617085943.GA19886@dhcp22.suse.cz>
References: <5704608.v8oGzytBA3@al>
 <20140616205245.GQ177152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616205245.GQ177152@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-06-14 16:52:45, Don Zickus wrote:
[...]
> Michal, do you remember why we needed preempt here?  I wouldn't think it
> mattered as we are not doing anything per-cpu specific.

Yes, you are right. Preempt can be enabled because we are always
accessing watchdog_ev on a specific cpu so reschedule doesn't matter.

> Cheers,
> Don
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 516203e..30e4822 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -527,10 +527,8 @@ static void update_timers_all_cpus(void)
>  	int cpu;
>  
>  	get_online_cpus();
> -	preempt_disable();
>  	for_each_online_cpu(cpu)
>  		update_timers(cpu);
> -	preempt_enable();
>  	put_online_cpus();
>  }
>  

-- 
Michal Hocko
SUSE Labs
