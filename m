Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935800Ab3DPKZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:25:01 -0400
Received: from 8bytes.org ([85.214.48.195]:45348 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935779Ab3DPKY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:24:59 -0400
Date: Tue, 16 Apr 2013 12:24:54 +0200
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
Message-ID: <20130416102454.GS6858@8bytes.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 16 12:24:57 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 516d26f923678072915870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 06:41:17PM -0400, Neil Horman wrote:
> +#ifdef CONFIG_IRQ_REMAP
> +static void __init intel_remapping_check(int num, int slot, int func)
> +{
> +	u8 revision;
> +
> +	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
> +
> +	/*
> +	 * Revision 0x13 of this chipset supports irq remapping
> +	 * but has an erratum that breaks its behavior, flag it as such
> +	 */
> +	if (revision == 0x13)
> +		irq_remap_broken = 1;
> +
> +}
> +#else

Any reason why you don't check this in the Intel IOMMU init code? You
would safe the ifdefs and you don't have to include
irq-remapping-internal header files somewhere else in the tree.


	Joerg


