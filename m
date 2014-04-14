Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaDNMIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaDNMIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:08:13 -0400
Date: Mon, 14 Apr 2014 14:09:22 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI/MSI: Phase out pci_enable_msi_block()
Message-ID: <20140414120921.GA32132@dhcp-26-207.brq.redhat.com>
References: <cover.1397458024.git.agordeev@redhat.com>
 <0b08613dc17cd608c1babc1f42b8919f60e1093f.1397458024.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b08613dc17cd608c1babc1f42b8919f60e1093f.1397458024.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:14:07AM +0200, Alexander Gordeev wrote:
> @@ -1244,7 +1241,7 @@ static inline void pcie_set_ecrc_checking(struct pci_dev *dev) { }
>  static inline void pcie_ecrc_get_policy(char *str) { }
>  #endif
>  
> -#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
> +#define pci_enable_msi(pdev)	pci_enable_msi_range(pdev, 1, 1)

Self-Nack, it should have been pci_enable_msi_exact(pdev, 1) ^^^

>  #ifdef CONFIG_HT_IRQ
>  /* The functions a driver should call */

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
