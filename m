Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaIQDUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:20:18 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64762 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaIQDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:20:16 -0400
Message-ID: <5418FDEC.40201@martingkelly.com>
Date: Tue, 16 Sep 2014 20:20:12 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>, x86@kernel.org, mingo@redhat.com
CC: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com> <5418ED4A.2030607@linux.intel.com>
In-Reply-To: <5418ED4A.2030607@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 07:09 PM, Li, Aubrey wrote:
> 
> Thanks to take care of this warning. How about this version?
> 
> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> index 0c424a6..cd91b57 100644
> --- a/arch/x86/kernel/pmc_atom.c
> +++ b/arch/x86/kernel/pmc_atom.c
> @@ -240,7 +240,7 @@ err:
>  static int pmc_setup_dev(struct pci_dev *pdev)
>  {
>  	struct pmc_dev *pmc = &pmc_device;
> -	int ret;
> +	int ret = 0;
>  
>  	/* Obtain ACPI base address */
>  	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
> @@ -269,7 +269,7 @@ static int pmc_setup_dev(struct pci_dev *pdev)
>  		return ret;
>  	}
>  #endif /* CONFIG_DEBUG_FS */
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> 
> Thanks,
> -Aubrey
> 

Thanks for the suggestion, Aubrey. Although that version would also work, it still has inline #ifdef, which is harder to read and goes against general Linux conventions:

https://www.kernel.org/doc/Documentation/SubmittingPatches
(section 2, "#ifdefs are ugly")
