Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaJVORd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:17:33 -0400
Received: from 8bytes.org ([81.169.241.247]:36513 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaJVORb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:17:31 -0400
Date: Wed, 22 Oct 2014 16:17:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141022141728.GG10074@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Tue, Oct 21, 2014 at 01:57:25PM +0200, Frank Blaschka wrote:
> Add a basic iommu for the s390 platform. The code is pretty simple
> since on s390 each PCI device has its own virtual io address space
> starting at the same vio address.

Are there any limitations on IOVA address space for the devices or can
be really any system physical address mapped starting from 0 to 2^64?

> For this a domain could hold only one pci device.

This bothers me, as it is not compatible with the IOMMU-API. I looked a
little bit into how the mappings are created, and it seems there is a
per-device dma_table.

Is there any reason a dma_table can't be per IOMMU domain and assigned
to multiple devices at the same time?

Otherwise the code looks quite simple and straight forward.


	Joerg


