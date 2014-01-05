Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaAERza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:55:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:58252 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaAERz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:55:29 -0500
X-IronPort-AV: E=Sophos;i="4.95,608,1384300800"; 
   d="scan'208";a="87713138"
Date: Sun, 5 Jan 2014 17:54:38 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 18/19] xen/pvh: Piggyback on PVHVM XenBus.
In-Reply-To: <1388777916-1328-19-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401051754280.8667@kaball.uk.xensource.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com> <1388777916-1328-19-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH is a PV guest with a twist - there are certain things
> that work in it like HVM and some like PV. For the XenBus
> mechanism we want to use the PVHVM mechanism.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  drivers/xen/xenbus/xenbus_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index ec097d6..01d59e6 100644
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
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
>  		ring_ops = &ring_ops_pv;
>  	else
>  		ring_ops = &ring_ops_hvm;
> -- 
> 1.8.3.1
> 
