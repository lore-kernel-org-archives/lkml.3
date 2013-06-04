Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3FDJYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:24:30 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:31344 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3FDJY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:24:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,798,1363132800"; 
   d="scan'208";a="5292384"
Message-ID: <1370337866.24512.90.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v2 2/5] arm64/xen: introduce asm/xen header files on
 arm64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Date: Tue, 4 Jun 2013 10:24:26 +0100
In-Reply-To: <1370273624-26976-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
	 <1370273624-26976-2-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 16:33 +0100, Stefano Stabellini wrote:
> asm/xen/hypercall.h, asm/xen/hypervisor.h, asm/xen/interface.h and
> asm/xen/page.h are indentical so to avoid code duplication we are just

"identical"

> including the original arm header files here.
> 
> asm/xen/events.h is slightly different, so introduce a different file
> here (use xchg to implement xchg_xen_ulong and pass regs->pstate to
> raw_irqs_disabled_flags).
> 
> Also introduce asm/hypervisor.h and asm/sync_bitops.h.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

[...]
> +/* sync_bitops functions are equivalent to the SMP implementation of the
> + * original functions, independently from CONFIG_SMP being defined.
> + *
> + * We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
> + * under Xen you might be communicating with a completely external entity
> + * who might be on another CPU (e.g. two uniprocessor guests communicating
> + * via event channels and grant tables). So we need a variant of the bit
> + * ops which are SMP safe even on a UP kernel.
> + */
> +
> +#define sync_set_bit(nr, p)            set_bit(nr, p)

Oh, arm64 seems to have optimised bitops now, which means I can ditch
the skanky versions in Xen in favour of these. Nice.

Ian.


