Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3EHMRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:17:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:43557 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3EHMRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:17:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4350245"
Message-ID: <1368015421.26321.263.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 2/3] xen/arm: do not handle VCPUOP_register_vcpu_info
 failures
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Julien Grall <julien.grall@citrix.com>
Date: Wed, 8 May 2013 13:17:01 +0100
In-Reply-To: <1368015080-5182-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
	 <1368015080-5182-2-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 13:11 +0100, Stefano Stabellini wrote:
> We expect VCPUOP_register_vcpu_info to succeed, do not try to handle
> failures.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 83d13b0..519acf9 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -165,13 +165,10 @@ static int __init xen_secondary_init(unsigned int cpu)
>  	info.offset = offset_in_page(vcpup);
>  
>  	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
> -	if (err) {
> -		pr_debug("register_vcpu_info failed: err=%d\n", err);
> -	} else {
> -		/* This cpu is using the registered vcpu info, even if
> -		   later ones fail to. */
> -		per_cpu(xen_vcpu, cpu) = vcpup;
> -	}
> +	if (err)
> +		BUG();

AKA BUG_ON(err);

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> +	per_cpu(xen_vcpu, cpu) = vcpup;
> +
>  	return 0;
>  }
>  


