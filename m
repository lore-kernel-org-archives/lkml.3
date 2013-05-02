Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3EBIVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:21:07 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:2463 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3EBIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:21:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4146133"
Message-ID: <1367482862.21869.28.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/arm: account for stolen ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 2 May 2013 09:21:02 +0100
In-Reply-To: <1367436460-10183-3-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
	 <1367436460-10183-3-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 20:27 +0100, Stefano Stabellini wrote:
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index d30042e..8f040a0 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -14,6 +14,7 @@
>  #include <xen/xen-ops.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <asm/arch_timer.h>
>  #include <asm/system_misc.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqreturn.h>
> @@ -172,6 +173,8 @@ static int __init xen_secondary_init(unsigned int cpu)
>  		   later ones fail to. */
>  		per_cpu(xen_vcpu, cpu) = vcpup;
>  	}
> +
> +	xen_setup_runstate_info(cpu);

Is this called for the boot processor too?

(do you have a linux-next branch where I can easily find the baseline
for this series?)

Ian.

