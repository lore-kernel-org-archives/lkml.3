Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaACRWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:22:54 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24164 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaACRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:22:53 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89604619"
Date: Fri, 3 Jan 2014 17:22:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 16/18] xen/pvh: Piggyback on PVHVM XenBus.
In-Reply-To: <1388550945-25499-17-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031721380.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-17-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH is a PV guest with a twist - there are certain things
> that work in it like HVM and some like PV. For the XenBus
> mechanism we want to use the PVHVM mechanism.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xenbus/xenbus_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index ec097d6..7f7c454 100644
> --- a/drivers/xen/xenbus/xenbus_client.c
> +++ b/drivers/xen/xenbus/xenbus_client.c
> @@ -45,6 +45,7 @@
>  #include <xen/grant_table.h>
>  #include <xen/xenbus.h>
>  #include <xen/xen.h>
> +#include <xen/features.h>
>  
>  #include "xenbus_probe.h"
>  
> @@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
>  
>  void __init xenbus_ring_ops_init(void)
>  {
> -	if (xen_pv_domain())
> +	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))

As I wrote in the other email, this should be

if (!xen_feature(XENFEAT_auto_translated_physmap))


>  		ring_ops = &ring_ops_pv;
>  	else
>  		ring_ops = &ring_ops_hvm;
> -- 
> 1.8.3.1
> 
