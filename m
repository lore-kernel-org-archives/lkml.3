Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab3DOPee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:34:34 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35167 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130415145834.GR6858@8bytes.org>
References: <1365966722-1804-1-git-send-email-Varun.Sethi@freescale.com> <20130415145834.GR6858@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 15 Apr 2013 09:34:11 -0600
Message-ID: <CAErSpo7gsSLsa1DOix7-LRqQbpfFuf3=KAubXhwCEuqA7041EQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
To: Joerg Roedel <joro@8bytes.org>
Cc: Varun Sethi <Varun.Sethi@freescale.com>, stuart.yoder@freescale.com,
        scottwood@freescale.com,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 8:58 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Mon, Apr 15, 2013 at 12:42:00AM +0530, Varun Sethi wrote:
>> swap_pci_ref function is used by the IOMMU API code for swapping pci device
>> pointers, while determining the iommu group for the device.
>> Currently this function was being implemented for different IOMMU drivers.
>> This patch moves the function to pci.h so that the implementation can be
>> shared across various IOMMU drivers.
>
> The function is only used in IOMMU code, so I think its fine to keep it
> there (unless Bjorn disagrees and wants it in PCI code).

I agree; I don't think there's much benefit in putting something under
#ifdef CONFIG_IOMMU_API into pci.h.  Maybe there is or could be a
shared iommu header file?

Bjorn
