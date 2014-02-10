Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBJKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:32:33 -0500
Received: from smtp.citrix.com ([66.165.176.89]:62325 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbaBJKcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:32:18 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="101262090"
Message-ID: <52F8AAAF.5040909@citrix.com>
Date: Mon, 10 Feb 2014 10:32:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 3/4] drivers: xen: Move prototype declaration to appropriate
 header file from arch/x86/xen/xen-ops.h
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com> <a609cbd7fcce1a4f5df0b00e3f866461b9ad071f.1391943416.git.rashika.kheria@gmail.com>
In-Reply-To: <a609cbd7fcce1a4f5df0b00e3f866461b9ad071f.1391943416.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 11:08, Rashika Kheria wrote:
> Move prototype declaration to header file include/xen/xen-ops.h from
> arch/x86/xen/xen-ops.h because they are used by more than one file.
> 
> This eliminates the following warning in drivers/xen/events/:
> drivers/xen/events_2l.c:1231:13: warning: no previous prototype for ‘xen_debug_interrupt’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
[...]
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -2,6 +2,7 @@
>  #define INCLUDE_XEN_OPS_H
>  
>  #include <linux/percpu.h>
> +#include <linux/interrupt.h>
>  #include <asm/xen/interface.h>
>  
>  DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
> @@ -35,4 +36,6 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  			       int numpgs, struct page **pages);
>  
>  bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
> +
> +irqreturn_t xen_debug_interrupt(int irq, void *dev_id);

This should be moved to include/xen/events.h instead.

David
