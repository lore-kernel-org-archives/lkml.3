Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3HUHDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:03:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52495 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3HUHC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:02:59 -0400
Date: Wed, 21 Aug 2013 00:02:55 -0700 (PDT)
Message-Id: <20130821.000255.1258155583733908892.davem@davemloft.net>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com
Subject: Re: [PATCH] VMXNET3: Add support for virtual IOMMU
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377020012-1839-1-git-send-email-acking@vmware.com>
References: <1377020012-1839-1-git-send-email-acking@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 00:02:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>
Date: Tue, 20 Aug 2013 10:33:32 -0700

> We can't just do virt_to_phys() on memory that we pass to the device and
> expect it to work in presence of a virtual IOMMU.  We need to add IOMMU
> mappings for such DMAs to work correctly.  Fix that with
> pci_alloc_consistent() where possible, or pci_map_single() where the
> mapping is short-lived or we don't control the allocation (netdev).
> 
> Also fix two small bugs:
> 1) use after free of rq->buf_info in vmxnet3_rq_destroy()
> 2) a cpu_to_le32() that should have been a cpu_to_le64()
> 
> Acked-by: George Zhang <georgezhang@vmware.com>
> Acked-by: Aditya Sarwade <asarwade@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>

Please use dma_alloc_coherent() (or in fact dma_zalloc_coherent()),
dma_map_single() et al., because they are preferred and in particular
allow specification of GFP_* flags.
