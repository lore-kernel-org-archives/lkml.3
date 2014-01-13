Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaAMPwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:52:17 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:40734 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:52:13 -0500
Date: Mon, 13 Jan 2014 16:52:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH] s390: delete new instances of __cpuinit usage
Message-ID: <20140113165205.3d81070b@mschwide>
In-Reply-To: <1389366050-25210-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389366050-25210-1-git-send-email-paul.gortmaker@windriver.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011315-5024-0000-0000-00000862CE0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014 10:00:50 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Commit 8c069ff4bd6063a3f15e606c882e03f75c7e7711 ("s390/perf: add
> support for the CPU-Measurement Sampling Facility") added a new
> instance of the __cpuinit macro usage.
> 
> We removed this a couple versions ago; we now want to remove
> the compat no-op stubs.  Introducing new users is not what
> we want to see at this point in time, as it will break once
> the stubs are gone.
> 
> Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [Patch based on today's linux-next tree, so if s390 next content
>  gets rebased, then the above commit ID will be invalidated; if it
>  _does_ get rebased, then feel free to squash this fix into the orig.]
> 
>  arch/s390/kernel/perf_cpum_sf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
> index 3c3bc8d7b220..ce3a1d9c521b 100644
> --- a/arch/s390/kernel/perf_cpum_sf.c
> +++ b/arch/s390/kernel/perf_cpum_sf.c
> @@ -1512,7 +1512,7 @@ static void cpumf_measurement_alert(struct ext_code ext_code,
>  	}
>  }
> 
> -static int __cpuinit cpumf_pmu_notifier(struct notifier_block *self,
> +static int cpumf_pmu_notifier(struct notifier_block *self,
>  					unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (long) hcpu;

Applied to linux-s390 for the next merge window. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

