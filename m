Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaFPU6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:58:50 -0400
Received: from lekensteyn.nl ([178.21.112.251]:44603 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbaFPU6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:58:49 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Don Zickus <dzickus@redhat.com>
Cc: mhocko@suse.cz, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: Writing watchdog_thresh triggers BUG: sleeping function called from invalid context
Date: Mon, 16 Jun 2014 22:58:44 +0200
Message-ID: <1583331.cjuWMhE6Gz@al>
User-Agent: KMail/4.13.2 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140616205245.GQ177152@redhat.com>
References: <5704608.v8oGzytBA3@al> <20140616205245.GQ177152@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2014 16:52:45 Don Zickus wrote:
> On Mon, Jun 16, 2014 at 04:12:44PM +0200, Peter Wu wrote:
> > Hi,
> > 
> > Writing to /proc/sys/kernel/watchdog_thresh causes the following BUG in
> > at least v3.13-rc2-625-g06151db, v3.15 and v3.16-rc1. Kernel config is
> > attached.
> > 
> > It was originally found on bare metal, since then reproduced in QEMU in
> > init, and when directly executing it.
> > 
> > Regards,
> > Peter
> 
> Hi Peter,
> 
> I assume the following patch will work?

Yes, the patch works (no more BUG). No idea whether it is
(in)correct though.

Regards,
Peter

> Michal, do you remember why we needed preempt here?  I wouldn't think it
> mattered as we are not doing anything per-cpu specific.
> 
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

