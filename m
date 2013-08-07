Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3HGRUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:20:45 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:56321 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3HGRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130807130950.GF2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-13-git-send-email-roy.franz@linaro.org>
	<20130807130950.GF2515@console-pimps.org>
Date: Wed, 7 Aug 2013 10:20:42 -0700
Message-ID: <CAFECyb_ZoCCMs75FLtGewfFQy1m5aVw6s5Jv1H1vaxg976qFNA@mail.gmail.com>
Subject: Re: [PATCH 12/17] Add proper definitions for some EFI function pointers.
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 6:09 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 06 Aug, at 08:45:08PM, Roy Franz wrote:
>> The x86/AMD64 EFI stubs must us a call wrapper to convert between
>> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
>> the ABIs are compatible, so we can directly invoke the function
>> pointers.  The functions that are used by the ARM stub are updated
>> to match the EFI definitions.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  include/linux/efi.h |   42 +++++++++++++++++++++++++-----------------
>>  1 file changed, 25 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 51f5641..96bb866 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -39,6 +39,8 @@
>>  typedef unsigned long efi_status_t;
>>  typedef u8 efi_bool_t;
>>  typedef u16 efi_char16_t;            /* UNICODE character */
>> +typedef u64 efi_physical_addr_t;
>> +typedef void *efi_handle_t;
>>
>>
>>  typedef struct {
>> @@ -96,6 +98,7 @@ typedef     struct {
>>  #define EFI_MEMORY_DESCRIPTOR_VERSION        1
>>
>>  #define EFI_PAGE_SHIFT               12
>> +#define EFI_PAGE_SIZE                (1UL << EFI_PAGE_SHIFT)
>
> It would be worth getting rid of the EFI_PAGE_SIZE definition in
> arch/x86/boot/compressed/eboot.h now that we have one here.
>
> --
> Matt Fleming, Intel Open Source Technology Center

I'll get this in the next version.

Thanks,
Roy
