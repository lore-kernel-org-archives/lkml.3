Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaBJL0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:26:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:59931 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaBJL0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:26:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="99436056"
Message-ID: <52F8B746.9020008@citrix.com>
Date: Mon, 10 Feb 2014 11:25:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <josh@joshtriplett.org>
Subject: Re: [PATCH 4/4] drivers: xen: Move prototype declaration to header
 file include/xen/xen-ops.h from arch/x86/xen/xen-ops.h
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com> <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
In-Reply-To: <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 11:12, Rashika Kheria wrote:
> Move prototype declaration to header file include/xen/xen-ops.h from
> arch/x86/xen/xen-ops.h because it is used by more than one file. Also,
> remove else condition from xen/events/events_base.c to eliminate
> conflicting definitions when CONFIG_XEN_PVHVM is not defined.
> 
> This eliminates the following warning in xen/events/events_base.c:
> drivers/xen/events/events_base.c:1640:6: warning: no previous prototype for ‘xen_callback_vector’ [-Wmissing-prototypes]
[...]
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -38,4 +38,11 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
>  
>  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
> +
> +#ifdef CONFIG_XEN_PVHVM
> +void xen_callback_vector(void);
> +#else
> +static inline void xen_callback_vector(void) {}
> +#endif
> +

This should be in include/xen/events.h

David
