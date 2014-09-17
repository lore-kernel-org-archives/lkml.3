Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaIQDop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:44:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:56059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaIQDoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:44:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="574215164"
Message-ID: <541903A9.7090301@linux.intel.com>
Date: Wed, 17 Sep 2014 11:44:41 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, x86@kernel.org, mingo@redhat.com
CC: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com> <5418ED4A.2030607@linux.intel.com> <5418FDEC.40201@martingkelly.com>
In-Reply-To: <5418FDEC.40201@martingkelly.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 11:20, Martin Kelly wrote:
> On 09/16/2014 07:09 PM, Li, Aubrey wrote:
>>
>> Thanks to take care of this warning. How about this version?
>>
>> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
>> index 0c424a6..cd91b57 100644
>> --- a/arch/x86/kernel/pmc_atom.c
>> +++ b/arch/x86/kernel/pmc_atom.c
>> @@ -240,7 +240,7 @@ err:
>>  static int pmc_setup_dev(struct pci_dev *pdev)
>>  {
>>  	struct pmc_dev *pmc = &pmc_device;
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	/* Obtain ACPI base address */
>>  	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
>> @@ -269,7 +269,7 @@ static int pmc_setup_dev(struct pci_dev *pdev)
>>  		return ret;
>>  	}
>>  #endif /* CONFIG_DEBUG_FS */
>> -	return 0;
>> +	return ret;
>>  }
>>  
>>  /*
>>
>> Thanks,
>> -Aubrey
>>
> 
> Thanks for the suggestion, Aubrey. Although that version would also work, it still has inline #ifdef, which is harder to read and goes against general Linux conventions:

Why do you want to call pmc_dbgfs_register() anyway even if
CONFIG_DEBUG_FS=n?

Thanks,
-Aubrey

> 
> https://www.kernel.org/doc/Documentation/SubmittingPatches
> (section 2, "#ifdefs are ugly")
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

