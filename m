Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbaH0XYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:24:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53212 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965120AbaH0XYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:24:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, rafael.j.wysocki@intel.com,
        dirk.j.brandewie@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] intel_pstate: Turn per cpu printk into pr_debug
Date: Thu, 28 Aug 2014 01:43:28 +0200
Message-ID: <9793239.74BuYFjUCF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53FE151E.6010708@intel.com>
References: <1409159828-16168-1-git-send-email-andi@firstfloor.org> <53FE151E.6010708@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 10:27:58 AM Dirk Brandewie wrote:
> On 08/27/2014 10:17 AM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > On larger systems intel_pstate currently spams the boot up
> > log with its "Intel pstate controlling ..." message for each CPU.
> > It's the only subsystem that prints a message for each
> > CPU.
> >
> > Turn the message into a pr_debug.
> >
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Queued up for 3.17-rc3, thanks!

> > ---
> >   drivers/cpufreq/intel_pstate.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index c5eac94..17be734 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -688,7 +688,7 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
> >
> >   	add_timer_on(&cpu->timer, cpunum);
> >
> > -	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
> > +	pr_debug("Intel pstate controlling: cpu %d\n", cpunum);
> >
> >   	return 0;
> >   }
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
