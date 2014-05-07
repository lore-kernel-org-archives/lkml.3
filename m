Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaEGH72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:59:28 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56854 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaEGH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:59:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Date: Wed, 07 May 2014 09:58:58 +0200
Message-ID: <45161364.3Gyo1xJJLV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140506224840.17968.29010.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140506224840.17968.29010.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:E16mmxeYddAl7joPGPCR52+xdjUnczhEV0y+whx7Eip
 jG6vWfs8K9wYysv+0FMgPMESMnqVpymjfMk6GcCArWn+BC/+HT
 dJxZF3Pci9Fvn7hpgK35QCgRdNZWWPEq5gxmmC/u/GfD4tAzS+
 1PH07EoE4v6F2hy6RYrGX6AFBz5AkyuXl3/vPr41sIp2uLM78N
 a4Yt4EZmu0yPgBhijFy5RmfM8pEgPEtrSl95KaeramQ0ZgbO04
 bganhAVDtG9fbDFNwguDKH3rAv+QZVfbJW00Jg583HCLTVyq5F
 lr2SSraQJKRRIt/2+kU2xxRqRUsTvnIXATu33LXmX/d4E2MINr
 HQwTwqwFLicowtic/Wlw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 16:48:40 Bjorn Helgaas wrote:
> Convert the "iova" arguments of iommu_map(), iommu_unmap(), etc., from
> "unsigned long" to dma_addr_t.
> 
> bb5547acfcd8 ("iommu/fsl: Make iova dma_addr_t in the iommu_iova_to_phys
> API") did this for iommu_iova_to_phys(), but didn't fix the rest of the
> IOMMU API.

This patch looks 100% correct, but I'm not convinced it's a good idea:
On 32-bit platforms (i.e. most of the ones you change), doing 64-bit
arithmetic has a noticeable overhead. I am not aware of an IOMMU that
actually uses 64-bit DMA addresses on its slave side, usually they
are used to translate addresses from 32-bit masters into 64-bit
memory addresses, so using 'unsigned long' seems better from a practical
point of view as opposed to the strict type correctness.

	Arnd
