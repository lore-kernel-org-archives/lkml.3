Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBXKgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:36:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20921 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaBXKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:36:42 -0500
Date: Mon, 24 Feb 2014 13:36:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        haiyangz@microsoft.com
Subject: Re: [PATCH v2 1/5] Drivers: hv: vmbus: Extract the mmio information
 from DSDT
Message-ID: <20140224103623.GF26722@mwanda>
References: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
 <1393237516-28545-2-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393237516-28545-2-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:25:12AM +0100, Gerd Hoffmann wrote:
> -static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *irq)
> +static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
>  {
> +	switch (res->type) {
> +	case ACPI_RESOURCE_TYPE_IRQ:
> +		irq = res->data.irq.interrupts[0];
>  
> -	if (res->type == ACPI_RESOURCE_TYPE_IRQ) {
> -		struct acpi_resource_irq *irqp;
> -		irqp = &res->data.irq;
> -
> -		*((unsigned int *)irq) = irqp->interrupts[0];

Add a /* fall through */ comment here.

> +	case ACPI_RESOURCE_TYPE_ADDRESS64:
> +		hyperv_mmio_start = res->data.address64.minimum;
> +		hyperv_mmio_size = res->data.address64.address_length;
>  	}

regards,
dan carpenter

