Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaAaSRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:17:10 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:64749 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbaAaSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:17:08 -0500
Message-ID: <52EBF6BE.8000201@cogentembedded.com>
Date: Fri, 31 Jan 2014 22:17:18 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 12/34] e1000e: Use pci_enable_msix_range()
References: <cover.1391172839.git.agordeev@redhat.com> <0ec36309e17031a66d3a6ab489fc60702b6d76b3.1391172839.git.agordeev@redhat.com>
In-Reply-To: <0ec36309e17031a66d3a6ab489fc60702b6d76b3.1391172839.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/31/2014 06:08 PM, Alexander Gordeev wrote:

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c |    9 +++++----
>   1 files changed, 5 insertions(+), 4 deletions(-)

> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6d91933..7735d1a 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -2041,10 +2041,11 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
>   				for (i = 0; i < adapter->num_vectors; i++)
>   					adapter->msix_entries[i].entry = i;
>
> -				err = pci_enable_msix(adapter->pdev,
> -						      adapter->msix_entries,
> -						      adapter->num_vectors);
> -				if (err == 0)
> +				err = pci_enable_msix_range(adapter->pdev,
> +							adapter->msix_entries,
> +							adapter->num_vectors,
> +							adapter->num_vectors);

    You should align all 'adapter' references under each other, according to 
networking coding rules.

WBR, Sergei

