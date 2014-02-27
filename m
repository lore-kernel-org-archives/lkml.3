Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaB0PLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:11:43 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:2860 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaB0PLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:11:41 -0500
Message-ID: <1393513469.6784.58.camel@misato.fc.hp.com>
Subject: Re: [PATCH 03/46] kernel: Move prototype declaration to header file
 include/linux/cpu.h
From: Toshi Kani <toshi.kani@hp.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Jones <drjones@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        David Miller <davem@davemloft.net>, josh@joshtriplett.org
Date: Thu, 27 Feb 2014 08:04:29 -0700
In-Reply-To: <2f6da4289a80fcde70aec12f65c135fbf719e338.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	 <2f6da4289a80fcde70aec12f65c135fbf719e338.1393493276.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 16:42 +0530, Rashika Kheria wrote:
> Add prototype declaration to header file include/linux/cpu.h because
> they are used by more than one file.
> 
> This eliminates the following warning in kernel/cpu.c:
> kernel/cpu.c:512:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_begin’ [-Wmissing-prototypes]
> kernel/cpu.c:516:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_end’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  arch/x86/kernel/smpboot.c |    1 +
>  include/linux/cpu.h       |    2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a32da80..e428764 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -49,6 +49,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/err.h>
>  #include <linux/nmi.h>
> +#include <linux/cpu.h>
>  #include <linux/tboot.h>
>  #include <linux/stackprotector.h>
>  #include <linux/gfp.h>
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 03e235ad..9f633b0 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -38,6 +38,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
>  
>  extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
>  extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
> +void arch_enable_nonboot_cpus_begin(void);
> +void arch_enable_nonboot_cpus_end(void);

Can we simply include linux/smp.h, which defines them already?

Thanks,
-Toshi



>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  extern void unregister_cpu(struct cpu *cpu);


