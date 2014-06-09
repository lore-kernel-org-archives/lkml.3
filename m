Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbaFIXWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:22:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:47290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaFIXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:22:45 -0400
Date: Tue, 10 Jun 2014 01:22:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 12/42] x86, ioapic: kill static variable nr_irqs_gsi
In-Reply-To: <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1406100121090.3830@nanos>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Jiang Liu wrote:
>  unsigned int arch_dynirq_lower_bound(unsigned int from)
>  {
> -	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
> +	unsigned int min = gsi_top + NR_IRQS_LEGACY;

Why is this gsi_top + NR_IRQ_LEGACY? The legacy interrupts are part of
the gsi space, aren't they?

Thanks,

	tglx
