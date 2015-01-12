Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbbALQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:09:27 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:50424 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbALQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:09:25 -0500
MIME-Version: 1.0
In-Reply-To: <20150112114600.GE26589@codeblueprint.co.uk>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
	<1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
	<20150112114600.GE26589@codeblueprint.co.uk>
Date: Mon, 12 Jan 2015 16:09:24 +0000
Message-ID: <CAKv+Gu9BQFEEpEpF3-O98W-kBYQC9yKf39ee2gvznuZYPiCo-g@mail.gmail.com>
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI stub
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Mark Salter <msalter@redhat.com>,
        Geoff Levand <geoff.levand@linaro.org>, Dave Young <dyoung@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 January 2015 at 11:46, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Thu, 08 Jan, at 06:48:32PM, Ard Biesheuvel wrote:
>> @@ -46,4 +54,26 @@ extern void efi_idmap_init(void);
>>
>>  #define EFI_ALLOC_ALIGN              SZ_64K
>>
>> +/*
>> + * On ARM systems, virtually remapped UEFI runtime services are set up in three
>> + * distinct stages:
>> + * - The stub retrieves the final version of the memory map from UEFI, populates
>> + *   the virt_addr fields and calls the SetVirtualAddressMap() [SVAM] runtime
>> + *   service to communicate the new mapping to the firmware (Note that the new
>> + *   mapping is not live at this time)
>> + * - During early boot, the page tables are allocated and populated based on the
>> + *   virt_addr fields in the memory map, but only if all descriptors with the
>> + *   EFI_MEMORY_RUNTIME attribute have a non-zero value for virt_addr. If this
>> + *   succeeds, the EFI_VIRTMAP flag is set to indicate that the virtual mappings
>> + *   have been installed successfully.
>> + * - During an early initcall(), the UEFI Runtime Services are enabled and the
>> + *   EFI_RUNTIME_SERVICES bit set if some conditions are met, i.e., we need a
>> + *   non-early mapping of the UEFI system table, and we need to have the virtmap
>> + *   installed.
>> + */
>> +#define EFI_VIRTMAP          EFI_ARCH_1
>
> Lucid. Thanks, Ard!
>

Cheers Matt

It appears this series is converging in time for 3.20, but this patch
still lacks acked/reviewed-bys

Are you ok with the remainder of the patch as well? In that case, may
I have your ack so the series can be merged through the arm64 tree?

-- 
Ard.
