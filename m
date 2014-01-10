Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaAJPdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:33:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37526 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaAJPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:33:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,638,1384300800"; 
   d="scan'208";a="89571796"
Message-ID: <52D012D9.1010602@citrix.com>
Date: Fri, 10 Jan 2014 15:33:45 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>
Subject: Re: randconfig build error with next-20140108, in drivers/xen/platform-pci.c
References: <CA+r1ZhinEQiBzonB_+ev_9hry+-7wscEVWcwqW46ExjGC2SYYg@mail.gmail.com> <20140110150738.GC19124@phenom.dumpdata.com>
In-Reply-To: <20140110150738.GC19124@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 15:07, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 08, 2014 at 03:32:00PM -0700, Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> drivers/xen/platform-pci.c: In function ‘platform_pci_init’:
>> drivers/xen/platform-pci.c:131:2: error: implicit declaration of
>> function ‘pci_request_region’ [-Werror=implicit-function-declaration]
>>   ret = pci_request_region(pdev, 1, DRV_NAME);
>>   ^
>> drivers/xen/platform-pci.c:170:2: error: implicit declaration of
>> function ‘pci_release_region’ [-Werror=implicit-function-declaration]
>>   pci_release_region(pdev, 0);
>>   ^
>> cc1: some warnings being treated as errors
>> make[2]: *** [drivers/xen/platform-pci.o] Error 1
>>
>> These warnings appeared too:
>>
>> warning: (XEN_PVH) selects XEN_PVHVM which has unmet direct
>> dependencies (HYPERVISOR_GUEST && XEN && PCI && X86_LOCAL_APIC)
> 
> Hey Jim,
> 
> This fix works for me:
> 
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index d88bfd6..01b9026 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -53,6 +53,5 @@ config XEN_DEBUG_FS
>  
>  config XEN_PVH
>  	bool "Support for running as a PVH guest"
> -	depends on X86_64 && XEN
> -	select XEN_PVHVM
> +	depends on X86_64 && XEN && XEN_PVHVM
>  	def_bool n
> 
> David, you OK with that? You suggested to use 'select' in the patchset
> instead of 'depends' and this throws away your suggestion.

Yes.

David
