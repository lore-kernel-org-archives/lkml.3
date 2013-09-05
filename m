Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3IEOcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:32:41 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:54734 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3IEOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:32:39 -0400
Message-ID: <52289604.50202@cogentembedded.com>
Date: Thu, 05 Sep 2013 18:32:36 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 5/6] AHCI: Check MRSM bit when multiple MSIs enabled
References: <cover.1378383792.git.agordeev@redhat.com> <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
In-Reply-To: <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/05/2013 04:54 PM, Alexander Gordeev wrote:

> Do not trust the hardware and always check if MSI
> Revert to Single Message mode was enforced. Fall
> back to the single MSI mode in case it did. Not
> doing so might screw up the interrupt handling.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/ata/ahci.c |   16 ++++++++++++++++
>   drivers/ata/ahci.h |    1 +
>   2 files changed, 17 insertions(+), 0 deletions(-)

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index a6bb618..af5d535 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1091,6 +1091,14 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
>   {}
>   #endif
>
> +static int ahci_get_mrsm(struct ahci_host_priv *hpriv)
> +{
> +	void __iomem *mmio = hpriv->mmio;
> +	u32 ctl = readl(mmio + HOST_CTL);
> +
> +	return (ctl & HOST_MRSM);

    Parens not needed here, in case you'll respin this once more.

WBR, Sergei

