Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaBTOHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:07:37 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:35064 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaBTOHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:07:36 -0500
Date: Thu, 20 Feb 2014 15:07:27 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v3 4/9] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
Message-ID: <20140220140727.GD4203@osiris>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
 <1392825976-17633-5-git-send-email-sudeep.holla@arm.com>
 <20140220083816.GA4203@osiris>
 <53060444.9010308@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53060444.9010308@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022014-6892-0000-0000-000007DF8305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:33:56PM +0000, Sudeep Holla wrote:
> Thanks, this info was helpful and looks like it's stupid mistake I did. I
> deleted a line unknowingly while trying to minimise the diff for show_cacheinfo.
> The below fix-up must work IIUC the issue. I will squash this in my next update
> if it works.
> 
> Regards,
> Sudeep
> 
> --->8
> 
> From 77690bc34b2b4b492377998019371f6e2f8f90b7 Mon Sep 17 00:00:00 2001
> From: Sudeep Holla <sudeep.holla@arm.com>
> Date: Thu, 20 Feb 2014 13:14:09 +0000
> Subject: [PATCH] fixup! s390: move cacheinfo sysfs to generic cacheinfo
>  infrastructure
> 
> ---
>  arch/s390/kernel/cache.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
> index e064f95..aeedb7f 100644
> --- a/arch/s390/kernel/cache.c
> +++ b/arch/s390/kernel/cache.c
> @@ -68,14 +68,15 @@ void show_cacheinfo(struct seq_file *m)
>  {
>  	int cpu = smp_processor_id(), idx;
>  	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
> -	struct cache_info *cache = this_cpu_ci->info_list;
> +	struct cache_info *cache;
> 
>  	for (idx = 0; idx < this_cpu_ci->num_leaves; idx++) {
> +		cache = this_cpu_ci->info_list + idx;
>  		seq_printf(m, "cache%-11d: ", idx);
>  		seq_printf(m, "level=%d ", cache->level);
>  		seq_printf(m, "type=%s ", cache_type_string[cache->type]);
>  		seq_printf(m, "scope=%s ",
> -			   cache->disable_sysfs ? "Private" : "Shared");
> +			   cache->disable_sysfs ? "Shared" : "Private");
>  		seq_printf(m, "size=%dK ", cache->size >> 10);
>  		seq_printf(m, "line_size=%u ", cache->coherency_line_size);
>  		seq_printf(m, "associativity=%d", cache->ways_of_associativity);

With this patch applied the output looks ok again.

Thanks,
Heiko

