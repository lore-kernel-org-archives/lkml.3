Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaABLtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:49:23 -0500
Received: from smtp.citrix.com ([66.165.176.89]:13919 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaABLtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:49:22 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="89196057"
Message-ID: <52C55222.7070801@citrix.com>
Date: Thu, 2 Jan 2014 11:48:50 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 18/18] xen/pvh: Support ParaVirtualized Hardware extensions
 (v2).
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-19-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-19-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH allows PV linux guest to utilize hardware extended capabilities,
> such as running MMU updates in a HVM container.
> 
> The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> with modifications):
> 
> "* the guest uses auto translate:
>  - p2m is managed by Xen
>  - pagetables are owned by the guest
>  - mmu_update hypercall not available
> * it uses event callback and not vlapic emulation,
> * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> 
> For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> PV guest with auto translate, although it does use hvm_op for setting
> callback vector."
> 
> Use .ascii and .asciz to define xen feature string. Note, the PVH
> string must be in a single line (not multiple lines with \) to keep the
> assembler from putting null char after each string before \.
> This patch allows it to be configured and enabled.
> 
> Lastly remove some of the scaffolding.
[...]
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -51,3 +51,11 @@ config XEN_DEBUG_FS
>  	  Enable statistics output and various tuning options in debugfs.
>  	  Enabling this option may incur a significant performance overhead.
>  
> +config XEN_PVH
> +	bool "Support for running as a PVH guest"
> +	depends on X86_64 && XEN && XEN_PVHVM

Would select XEN_PVHVM be more useful?  It may not be obvious to a user
that PV with hardware extension depends on HVM with PV extensions.

> +	default n
> +	help
> +	   This option enables support for running as a PVH guest (PV guest
> +	   using hardware extensions) under a suitably capable hypervisor.
> +	   If unsure, say N.

This help text needs to clearly state that PVH support is experimental
or a tech preview and the ABI is subject to change and PVH guests may
not run on newer hypervisors.  Unless the plan is to only merge the
Linux support once the hypervisor ABI is finalized.

David
