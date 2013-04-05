Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161995Ab3DEQQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:16:00 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:46591 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161938Ab3DEQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:15:59 -0400
Date: Fri, 5 Apr 2013 12:15:55 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        arnd@arndb.de, rob.herring@calxeda.com
Subject: Re: [PATCH v6 2/4] arm: prefer psci_smp_ops over mdesc->smp
In-Reply-To: <1365167495-18508-2-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1304051215270.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Stefano Stabellini wrote:

> If PSCI is available on the platform, prefer psci_smp_ops over the
> platform smp_ops.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/kernel/setup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 341efaa..dad3048 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -770,10 +770,10 @@ void __init setup_arch(char **cmdline_p)
>  	psci_init();
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
> -		if (mdesc->smp)
> -			smp_set_ops(mdesc->smp);
> -		else if (psci_smp_available())
> +		if (psci_smp_available())
>  			smp_set_ops(&psci_smp_ops);
> +		else if (mdesc->smp)
> +			smp_set_ops(mdesc->smp);
>  		smp_init_cpus();
>  	}
>  #endif
> -- 
> 1.7.2.5
> 
