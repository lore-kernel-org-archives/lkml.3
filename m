Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3EaVuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:50:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:55544 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3EaVt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:49:57 -0400
Message-ID: <1370036984.3928.144.camel@pasglop>
Subject: Re: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, scottwood@freescale.com,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 07:49:44 +1000
In-Reply-To: <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
	 <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 15:59 +0800, Zhao Chenhui wrote:
> Some features depend on the boot cpu, for instance, hibernate/suspend.
> So disable hotplug for the boot cpu.

Don't we have code to "move" the boot CPU around when that happens ?

Ben.

> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/kernel/sysfs.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> index e68a845..294b1c4e 100644
> --- a/arch/powerpc/kernel/sysfs.c
> +++ b/arch/powerpc/kernel/sysfs.c
> @@ -655,8 +655,10 @@ static int __init topology_init(void)
>  		 * CPU.  For instance, the boot cpu might never be valid
>  		 * for hotplugging.
>  		 */
> -		if (ppc_md.cpu_die)
> +		if (ppc_md.cpu_die && cpu != boot_cpuid)
>  			c->hotpluggable = 1;
> +		else
> +			c->hotpluggable = 0;
>  
>  		if (cpu_online(cpu) || c->hotpluggable) {
>  			register_cpu(c, cpu);


