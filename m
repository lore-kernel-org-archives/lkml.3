Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3FIPbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:31:43 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54114 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab3FIPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:31:42 -0400
Date: Sun, 9 Jun 2013 17:31:23 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Donald Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v3 07/27] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
Message-ID: <20130609153123.GD2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:53PM -0700, Yinghai Lu wrote:
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index a7967ce..c09e60d 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -1273,7 +1273,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>  	if (iommu->irq)
>  		return 0;
>  
> -	irq = create_irq();
> +	irq = create_irq_nr(0, iommu->node);
>  	if (!irq) {

This is okay. However you fix a bug here so you might want first fix the bug
with a Cc: stable tag and then do this.

>  		pr_err("IOMMU: no free vectors\n");
>  		return -EINVAL;

Sebastian
