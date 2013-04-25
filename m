Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3DYNso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:48:44 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:51274 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab3DYNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:48:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="3934454"
Message-ID: <1366897718.20256.546.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v4 1/7] xen/arm: actually pass a non-NULL percpu pointer
 to request_percpu_irq
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Thu, 25 Apr 2013 14:48:38 +0100
In-Reply-To: <1366831695-13214-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
	 <1366831695-13214-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 20:28 +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: Ian Campbell <ian.camjpbell@citrix.com>

> CC: stable@vger.kernel.org
> ---
>  arch/arm/xen/enlighten.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 8dc0605..99ce189 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -239,7 +239,7 @@ static int __init xen_init_events(void)
>  	xen_init_IRQ();
>  
>  	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
> -			"events", xen_vcpu)) {
> +			"events", &xen_vcpu)) {
>  		pr_err("Error requesting IRQ %d\n", xen_events_irq);
>  		return -EINVAL;
>  	}


