Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaIEVZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:25:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62912 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaIEVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:25:37 -0400
Date: Fri, 5 Sep 2014 15:25:28 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/2] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140905212528.GG8080@google.com>
References: <cover.1405160163.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1405160163.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 01:21:06PM +0200, Alexander Gordeev wrote:
> Hello,
> 
> This is a cleanup effort to get rid of useless arch_msi_check_device().
> I am not sure what were the reasons for its existence in the first place,
> but at the moment it appears totally unnecessary.
> 
> Thanks!
> 
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-pci@vger.kernel.org
> 
> Alexander Gordeev (2):
>   PCI/MSI/PPC: Remove arch_msi_check_device()
>   PCI/MSI: Remove arch_msi_check_device()

I applied these (with Michael's ack on the first, and v2 of the second) to
pci/msi for v3.18, thanks!
> 
>  arch/powerpc/include/asm/machdep.h     |    2 -
>  arch/powerpc/kernel/msi.c              |   12 +-------
>  arch/powerpc/platforms/cell/axon_msi.c |    9 ------
>  arch/powerpc/platforms/powernv/pci.c   |   19 +++---------
>  arch/powerpc/platforms/pseries/msi.c   |   42
>  ++++++++++----------------- arch/powerpc/sysdev/fsl_msi.c          |
>  12 ++------ arch/powerpc/sysdev/mpic_pasemi_msi.c  |   11 +------
>  arch/powerpc/sysdev/mpic_u3msi.c       |   28 +++++++-----------
>  arch/powerpc/sysdev/ppc4xx_hsta_msi.c  |   18 ++++--------
>  arch/powerpc/sysdev/ppc4xx_msi.c       |   19 ++++--------
>  drivers/pci/msi.c                      |   49
>  ++++++++----------------------- include/linux/msi.h                    |
>  3 -- 12 files changed, 63 insertions(+), 161 deletions(-)
> 
> -- 1.7.7.6
> 
> -- To unsubscribe from this list: send the line "unsubscribe linux-pci"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
