Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967576Ab3DRPpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:45:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34742 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967428Ab3DRPpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:45:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="20221874"
Date: Thu, 18 Apr 2013 16:44:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH] xen/arm: introduce xen_early_init, use PSCI on xen
In-Reply-To: <1366298167-12755-1-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1304181644060.7254@kaball.uk.xensource.com>
References: <1366298167-12755-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Stefano Stabellini wrote:
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index b002822..3006de4 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -176,11 +178,36 @@ static int __init xen_secondary_init(unsigned int cpu)
>  	return 0;
>  }
>  
> +static bool __init xen_smp_init(void)
> +{
> +#ifdef CONFIG_SMP
> +	/* If we are running on Xen, use PSCI if available.
> +	 * In any case do not try to use the native smp_ops. */
> +	if (psci_smp_available())
> +		smp_set_ops(&psci_smp_ops);
> +	return true;
> +#endif
> +}

Small mistake here: ifndef CONFIG_SMP, xen_smp_init won't have a return
value.
I'll fix and resend.
