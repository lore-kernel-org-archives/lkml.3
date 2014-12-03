Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaLCAZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:25:49 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:51533 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaLCAZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:25:48 -0500
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 19:25:48 EST
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <547E54EB.8070707@citrix.com>
Date: Wed, 03 Dec 2014 00:10:19 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        david.vrabel@citrix.com, jun.nakajima@intel.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [Xen-devel] [PATCH v4 0/2] xen/pci: Use APIC for MSIs when APIC
 virtualization is supported
References: <1417551553-22234-1-git-send-email-boris.ostrovsky@oracle.com> <20141202204825.GS357@laptop.dumpdata.com>
In-Reply-To: <20141202204825.GS357@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 20:48, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 02, 2014 at 03:19:11PM -0500, Boris Ostrovsky wrote:
>> Changes in v4:
>> * Added comment describing what we check for in pci_xen_init()
>>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>

>
>> Changes in v3:
>> * Explicitly include asm/apic.h in arch/x86/pci/xen.c for !CONFIG_SMP.
>>
>> Changes in v2:
>> * New version of cpuid.h file from Xen tree (with a couple of style adjustments)
>> * Whitespace cleanup
>>
>> Currently HVM guests handle MSI interrupts using pirqs/event channels, allowing
>> us to not issue APIC accesses that result in somewhat expensive VMEXITs. When
>> hardware supports APIC virtualization we don't need to use pirqs anymore
>> since now guest's APIC accesses can be handled by the processor itself.
>>
>> There are two patches in this series:
>>
>> 1. Move setting of x86_msi ops to a later point. The reason for doing so is that
>> we currently decide whether or not to use pirqs before kernel had a chance to
>> see whether it should be using x2APIC instead of plain APIC. Since hardware may
>> virtualize either or both of those two we can only make pirqs vs. APIC selection
>> after kernel has settled down on which APIC version it will use. (Note that
>> currently x2APIC is not used by HVM guests so technically this patch is not
>> necessary. However, it probably makes sense to apply it now to avoid
>> forgetting to do it when we enable x2APIC).
>>
>> 2. Set x86_msi ops to use pirqs only when APIC virtualization is not available.
>> The commit message describes performance improvements that this change brings.
>>
>>
>> Boris Ostrovsky (2):
>>   xen/pci: Defer initialization of MSI ops on HVM guests until after
>>     x2APIC has been set up
>>   xen/pci: Use APIC directly when APIC virtualization is supported by
>>     hardware
>>
>>  arch/x86/include/asm/xen/cpuid.h | 91 ++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/pci/xen.c               | 31 +++++++++++++-
>>  2 files changed, 120 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/x86/include/asm/xen/cpuid.h
>>
>> -- 
>> 1.8.1.4
>>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

