Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbaJ2N7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:59:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25278 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbaJ2N7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:59:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,810,1406592000"; 
   d="scan'208";a="187391153"
Message-ID: <5450F2CE.8070104@citrix.com>
Date: Wed, 29 Oct 2014 13:59:42 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <stefano.stabellini@eu.citrix.com>
CC: <linux-kernel@vger.kernel.org>, <jun.nakajima@intel.com>,
        <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v2 0/2] xen/pci: Use APIC for MSIs when APIC
 virtualization is supported
References: <1414425953-13987-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1414425953-13987-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/14 16:05, Boris Ostrovsky wrote:
> Changes in v2:
> * New version of cpuid.h file from Xen tree (with a couple of style adjustments)
> * Whitespace cleanup
> 
> Currently HVM guests handle MSI interrupts using pirqs/event channels, allowing
> us to not issue APIC accesses that result in somewhat expensive VMEXITs. When
> hardware supports APIC virtualization we don't need to use pirqs anymore
> since now guest's APIC accesses can be handled by the processor itself.
> 
> There are two patches in this series:
> 
> 1. Move setting of x86_msi ops to a later point. The reason for doing so is that
> we currently decide whether or not to use pirqs before kernel had a chance to
> see whether it should be using x2APIC instead of plain APIC. Since hardware may
> virtualize either or both of those two we can only make pirqs vs. APIC selection
> after kernel has settled down on which APIC version it will use. (Note that
> currently x2APIC is not used by HVM guests so technically this patch is not
> necessary. However, it probably makes sense to apply it now to avoid
> forgetting to do it when we enable x2APIC).
> 
> 2. Set x86_msi ops to use pirqs only when APIC virtualization is not available.
> The commit message describes performance improvements that this change brings.
> 
> Boris Ostrovsky (2):
>   xen/pci: Defer initialization of MSI ops on HVM guests until after
>     x2APIC has been set up
>   xen/pci: Use APIC directly when APIC virtualization is supported by
>     hardware

Applied to devel/for-linus-3.19.

Thanks.

David
