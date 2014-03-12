Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaCLHFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:05:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbaCLHFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:05:39 -0400
Date: Wed, 12 Mar 2014 08:05:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sfr@canb.auug.org.au,
        hpa@zytor.com
Subject: Re: [PATCH v2] perf/x86/uncore: fix compilation warning in
 snb_uncore_imc_init_box()
Message-ID: <20140312070523.GL30956@twins.programming.kicks-ass.net>
References: <20140311235329.GA28624@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311235329.GA28624@quad>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 12:53:30AM +0100, Stephane Eranian wrote:
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
> -	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
> -	addr = ((resource_size_t)addr_hi << 32) | addr_lo;
> +	  pci_read_config_dword(pdev, where + 4, &pci_dword);
> +	  addr |= ((resource_size_t)pci_dword << 32);
>  #endif

Indent fail there; fixed it.

FWIW; I thought of an even more horrible solution:

	resource_size_t addr;
	u32 *addr_ptr = &addr;

	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_ptr[0]);
#ifdef ..
	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_ptr[1]);
#endif

:-)
