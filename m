Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbbAWGyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:54:19 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39998 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbAWGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:54:16 -0500
Date: Fri, 23 Jan 2015 07:54:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [Resend Patch v4 14/16] smp, s390: Kill SMP single function call
 interrupt
Message-ID: <20150123065410.GA5101@osiris>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
 <1421991416-20297-15-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421991416-20297-15-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012306-0021-0000-0000-000002A75E53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 01:36:53PM +0800, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Acked-by: Heiko Carstens <heiko.carst...@de.ibm.com>

Is this really the patch I acked, whenever that was? Because the patch
description doesn't match what your patch does.
All it does is renaming ec_call_function_single to ec_call_function,
nothing else.

Could you please resend with a proper patch description?
Thanks!

> ---
>  arch/s390/kernel/smp.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 0b499f5cbe19..5b89eabc3a01 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -50,7 +50,7 @@
> 
>  enum {
>  	ec_schedule = 0,
> -	ec_call_function_single,
> +	ec_call_function,
>  	ec_stop_cpu,
>  };
> 
> @@ -416,8 +416,8 @@ static void smp_handle_ext_call(void)
>  		smp_stop_cpu();
>  	if (test_bit(ec_schedule, &bits))
>  		scheduler_ipi();
> -	if (test_bit(ec_call_function_single, &bits))
> -		generic_smp_call_function_single_interrupt();
> +	if (test_bit(ec_call_function, &bits))
> +		generic_smp_call_function_interrupt();
>  }
> 
>  static void do_ext_call_interrupt(struct ext_code ext_code,
> @@ -432,12 +432,12 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>  	int cpu;
> 
>  	for_each_cpu(cpu, mask)
> -		pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
> +		pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
>  }
> 
>  void arch_send_call_function_single_ipi(int cpu)
>  {
> -	pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
> +	pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
>  }
> 
>  #ifndef CONFIG_64BIT
> -- 
> 1.7.10.4
> 

