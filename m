Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947082Ab3BHUqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:46:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946959Ab3BHUqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:46:07 -0500
Message-ID: <511563F6.1080009@redhat.com>
Date: Fri, 08 Feb 2013 15:45:42 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 08/26] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org> <1360351703-20571-9-git-send-email-yinghai@kernel.org>
In-Reply-To: <1360351703-20571-9-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 02:28 PM, Yinghai Lu wrote:
> iommu irq's irq_desc should be on local node ram.
>
> Fix the return value checking problem.
>
> create_irq() will return -1 when fail to allocate.
> create_irq_nr() will return 0 when fail to allocate.
>
> here only check !irq, so need to change it to use create_irq_nr instead.
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> Cc: Joerg Roedel<joro@8bytes.org>
> Cc: Donald Dutile<ddutile@redhat.com>
> ---
>   drivers/iommu/dmar.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 174bb65..316b5a2 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -1263,7 +1263,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>   	if (iommu->irq)
>   		return 0;
>
> -	irq = create_irq();
> +	irq = create_irq_nr(0, iommu->node);
>   	if (!irq) {
>   		pr_err("IOMMU: no free vectors\n");
>   		return -EINVAL;
Good catch!

you can add my ack to it.

