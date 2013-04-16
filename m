Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090Ab3DPR0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:26:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38548 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045Ab3DPR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:26:13 -0400
Date: Tue, 16 Apr 2013 13:25:58 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130416172558.GD9241@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
 <20130416102454.GS6858@8bytes.org>
 <20130416133555.GB9241@hmsreliant.think-freely.org>
 <20130416163705.GT6858@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416163705.GT6858@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 06:37:05PM +0200, Joerg Roedel wrote:
> On Tue, Apr 16, 2013 at 09:35:56AM -0400, Neil Horman wrote:
> > Actually, hold on that last note, the intel iommu init code doesn't seem to
> > create any direct relationship between the set of iommu's and the pci_dev's that
> > implement them.  In the intel_irq_remapping_supported path I can loop over each
> > dmar_dhrd_unit, and interrogate each of the devices on its **devices list to see
> > if the device/vendor and revision ids match, but looking at the dhrd parsing
> > code, I'm not sure the iommu pci_dev is always going to be on that list.  That
> > seems like its going to be pretty ugly in and of itself.  Do you have a
> > suggested way to identify the pci_dev of the device we need in that path without
> > having to simply iterate over every device in that scope?
> 
> Hmkay, looks like this is a non-trivial problem. Here is what I suggest:
> Keep the early-quirk as in your current patch. But add a function to
> drivers/iommu/irq_remapping.c to disable irq-remapping and export that
> function via the header-file arch/x86/include/asm/irq_remapping.h. Use
> that function in the quirk instead of setting the disable-flag directly.
> This way you don't have to include any private header file from iommu
> code.
> 
Ok, that seems reasonable. I'll have a new patch in a day or so.

Thanks!
Neil

