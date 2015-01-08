Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbbAHW1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:27:23 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62901 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbAHW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:27:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-arm-kernel@lists.infradead.org, joro@8bytes.org,
        grant.likely@linaro.org, robh+dt@kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
Date: Thu, 08 Jan 2015 23:27:14 +0100
Message-ID: <2785994.gTZ9chGdKf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1934001.D0JfDRp1gF@wuerfel>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <54ADBB89.8070503@ti.com> <1934001.D0JfDRp1gF@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:SgiJIAjINj3Q0gplcAvMvak08hf/CXPVFTQera7T1RT1FPckZJX
 OZNppNlRRT/xuGS1zYVKsRwewd5Uqv4b9QbhrHt7/RdMFPloaDFTV2EmGzZa3v9XVilpSts
 3ZMy51H0L/l1WAr+MU/cmHoBHJzJuYnlqEseEej9nBA4/bFKlvRJPNSBSumvkHWRPGWiLsa
 olM3Q8aGxl38a2dpIuhGQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 09:56:39 Arnd Bergmann wrote:
> There is another interesting case, which is a USB host controller or
> something similar behind a PCI bus. These are quite common and also
> need to be handled in some form. Let's do just PCI first for now, but
> be aware that this will come next. Should we assume that the ID that
> is required for a device is either known from the device node, or
> that it comes from a PCI device? That means for the USB case, we will
> likely need to have some custom logic. There seems to be an implicit
> assumption all over the kernel that all devices have the same IOMMU
> instance, but we can't really rely on that here.
> 

Update: I've checked the USB implementation and we are lucky because
these interactions are all done by the USB host controller, and a
USB device is not itself DMA capable. We don't have to do anything
for USB.

	Arnd
