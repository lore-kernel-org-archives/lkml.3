Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3KUKh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:37:58 -0500
Received: from smtp.citrix.com ([66.165.176.89]:22517 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab3KUKh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:37:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,743,1378857600"; 
   d="scan'208";a="76735454"
Message-ID: <528DE282.5060806@citrix.com>
Date: Thu, 21 Nov 2013 10:37:54 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>, Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH 1/4] xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG
 areas.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> The PCI MMCONFIG area is usually reserved via the E820 so the Xen hypervisor
> is aware of these regions. But they can also be enumerated in the ACPI
> DSDT which means the hypervisor won't know of them until the initial
> domain informs it of via PHYSDEVOP_pci_mmcfg_reserved.
> 
> This is what this patch does for all of the MCFG regions that the
> initial domain is aware of (E820 enumerated and ACPI).
> 
> Reported-by:  Santosh Jodh <Santosh.Jodh@citrix.com>
> CC: Jan Beulich <JBeulich@suse.com>
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> CC: David Vrabel <david.vrabel@citrix.com>
> CC: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

> [v1: Redid it a bit]
> [v2: Dropped the P2M 1-1 setting]
> [v3: Check for Xen in-case we are running under baremetal]
> [v4: Wrap with CONFIG_PCI_MMCONFIG]

This sort of change list isn't useful in the long term. I'd prefer it if
this was after the --- divider.

> --- a/drivers/xen/pci.c
> +++ b/drivers/xen/pci.c
> @@ -26,6 +26,7 @@
> +		default:
> +			pr_warn("Failed to report MMCONFIG reservation"
> +				" state for %s to hypervisor"
> +				" (%d)\n",

Message strings shouldn't be split like this.

David
