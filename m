Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaKQLbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:31:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:60978 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKQLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:31:06 -0500
Date: Mon, 17 Nov 2014 12:30:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch V3 6/9] genirq: Introduce
 msi_domain_{alloc|free}_irqs()
In-Reply-To: <1416222202-28002-7-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411171230090.3909@nanos>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com> <1416222202-28002-7-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Jiang Liu wrote:
> +
> +/*
> + * Default structure for MSI interrupt allocation.
> + * Arch may overwrite it by defining msi_alloc_info_t.
> + */
> +struct msi_alloc_info {
> +	struct msi_desc			*desc;
> +	irq_hw_number_t			hwirq;
> +	union {
> +		unsigned long		ul;
> +		void			*ptr;
> +	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
> +};
> +
> +#ifndef msi_alloc_info_t
> +typedef struct msi_alloc_info msi_alloc_info_t;
> +#endif

Hmm. Do we really need that?

Thanks,

	tglx
