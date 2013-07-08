Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3GHHVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:21:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:44764 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3GHHVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:21:11 -0400
Message-ID: <1373268055.4446.31.camel@pasglop>
Subject: Re: [PATCH v2] powerpc: add real mode support for dma operations on
 powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 17:20:55 +1000
In-Reply-To: <1373258669-3130-1-git-send-email-aik@ozlabs.ru>
References: <1373123227-22969-6-git-send-email-aik@ozlabs.ru>
	 <1373258669-3130-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 14:44 +1000, Alexey Kardashevskiy wrote:

> diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
> index 25d76c4..7ea82c1 100644
> --- a/arch/powerpc/platforms/powernv/pci.h
> +++ b/arch/powerpc/platforms/powernv/pci.h
> @@ -52,6 +52,7 @@ struct pnv_ioda_pe {
>  	int			tce32_seg;
>  	int			tce32_segcount;
>  	struct iommu_table	tce32_table;
> +	phys_addr_t		it_index_rm;

Please ....

The fact that we hijack the it_index field of the iommu table
for the virtual address is bad enough, but really don't need
to perpetuate this :-)

Call the field something decent such as "tce_inval_reg_phys"

Cheers,
Ben.


