Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaHZS4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:56:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaHZSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:55:58 -0400
Message-ID: <53FCD816.6070108@infradead.org>
Date: Tue, 26 Aug 2014 11:55:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bugfix] x86, irq: Fix bug in setting IOAPIC pin attributes
References: <20140822124145.GF1660@lahna.fi.intel.com> <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 01:45, Jiang Liu wrote:
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 29290f554e79..66c2700c9f83 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3896,7 +3896,15 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
> +		/*
> +		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
> +		 * trigger and polarity attirbutes. Don't set the flag for that

		                        attributes.

> +		 * case so the first legacy IRQ user could reprogram the pin
> +		 * with real trigger and polarity attributes.
> +		 */

thanks,
-- 
~Randy
