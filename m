Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaBRKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:16:58 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61780 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaBRKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:16:56 -0500
Date: Tue, 18 Feb 2014 15:48:02 +0530 (IST)
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
X-X-Sender: hydrogen@as-rtp-infra-nw.cisco.com
To: Alexander Gordeev <agordeev@redhat.com>
cc: linux-kernel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>,
        Sujith Sankar <ssujith@cisco.com>,
        Govindarajulu Varadarajan <govindarajulu90@gmail.com>,
        Neel Patel <neepatel@cisco.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next 10/35] enic: Use pci_enable_msix_range() instead
 of pci_enable_msix()
In-Reply-To: <a5aee403375068dd23e6f22851effe47a7e89cee.1392717503.git.agordeev@redhat.com>
Message-ID: <alpine.LNX.2.03.1402181546150.11061@gmail.com>
References: <cover.1392717502.git.agordeev@redhat.com> <a5aee403375068dd23e6f22851effe47a7e89cee.1392717503.git.agordeev@redhat.com>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Feb 2014, Alexander Gordeev wrote:

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
>
looks good, thanks

Acked-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>



> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Christian Benvenuti <benve@cisco.com>
> Cc: Sujith Sankar <ssujith@cisco.com>
> Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
> Cc: Neel Patel <neepatel@cisco.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
> drivers/net/ethernet/cisco/enic/enic_main.c |    6 ++++--
> 1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
> index b740bfc..dcd58f2 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_main.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_main.c
> @@ -1796,7 +1796,8 @@ static int enic_set_intr_mode(struct enic *enic)
> 	    enic->cq_count >= n + m &&
> 	    enic->intr_count >= n + m + 2) {
>
> -		if (!pci_enable_msix(enic->pdev, enic->msix_entry, n + m + 2)) {
> +		if (pci_enable_msix_range(enic->pdev, enic->msix_entry,
> +					  n + m + 2, n + m + 2) > 0) {
>
> 			enic->rq_count = n;
> 			enic->wq_count = m;
> @@ -1815,7 +1816,8 @@ static int enic_set_intr_mode(struct enic *enic)
> 	    enic->wq_count >= m &&
> 	    enic->cq_count >= 1 + m &&
> 	    enic->intr_count >= 1 + m + 2) {
> -		if (!pci_enable_msix(enic->pdev, enic->msix_entry, 1 + m + 2)) {
> +		if (pci_enable_msix_range(enic->pdev, enic->msix_entry,
> +					  1 + m + 2, 1 + m + 2) > 0) {
>
> 			enic->rq_count = 1;
> 			enic->wq_count = m;
> -- 
> 1.7.7.6
>
>
