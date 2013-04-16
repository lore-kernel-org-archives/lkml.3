Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab3DPQhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:37:14 -0400
Received: from 8bytes.org ([85.214.48.195]:45896 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935552Ab3DPQhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:37:12 -0400
Date: Tue, 16 Apr 2013 18:37:05 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130416163705.GT6858@8bytes.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
 <20130416102454.GS6858@8bytes.org>
 <20130416133555.GB9241@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416133555.GB9241@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 16 18:37:08 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 516d7e3423672144916604
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:35:56AM -0400, Neil Horman wrote:
> Actually, hold on that last note, the intel iommu init code doesn't seem to
> create any direct relationship between the set of iommu's and the pci_dev's that
> implement them.  In the intel_irq_remapping_supported path I can loop over each
> dmar_dhrd_unit, and interrogate each of the devices on its **devices list to see
> if the device/vendor and revision ids match, but looking at the dhrd parsing
> code, I'm not sure the iommu pci_dev is always going to be on that list.  That
> seems like its going to be pretty ugly in and of itself.  Do you have a
> suggested way to identify the pci_dev of the device we need in that path without
> having to simply iterate over every device in that scope?

Hmkay, looks like this is a non-trivial problem. Here is what I suggest:
Keep the early-quirk as in your current patch. But add a function to
drivers/iommu/irq_remapping.c to disable irq-remapping and export that
function via the header-file arch/x86/include/asm/irq_remapping.h. Use
that function in the quirk instead of setting the disable-flag directly.
This way you don't have to include any private header file from iommu
code.


	Joerg


