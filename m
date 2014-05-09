Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaEIHim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:38:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41644 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaEIHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:38:41 -0400
Date: Fri, 9 May 2014 09:38:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze"
 sleep state
Message-ID: <20140509073835.GB4965@xo-6d-61-c0.localdomain>
References: <2548502.zJ1no3NhRc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2548502.zJ1no3NhRc@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-05-05 00:51:54, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If freeze_enter() is called, we want to bypass the current cpuidle
> governor and always use the deepest available (that is, not disabled)
> C-state, because we want to save as much energy as reasonably possible
> then and runtime latency constraints don't matter at that point, since
> the system is in a sleep state anyway.

Would there be way to pass the parameter "go to deepest" instead of adding
global state for this?
								Pavel

> Index: linux-pm/kernel/power/suspend.c
> ===================================================================
> --- linux-pm.orig/kernel/power/suspend.c
> +++ linux-pm/kernel/power/suspend.c
> @@ -54,9 +54,11 @@ static void freeze_begin(void)
>  
>  static void freeze_enter(void)
>  {
> +	cpuidle_use_deepest_state(true);
>  	cpuidle_resume();
>  	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
>  	cpuidle_pause();
> +	cpuidle_use_deepest_state(false);
>  }
>  
>  void freeze_wake(void)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
