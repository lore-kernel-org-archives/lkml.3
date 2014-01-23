Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaAWVk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:40:58 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37685 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAWVk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:40:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org> <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 23 Jan 2014 13:40:34 -0800
Message-ID: <CAGTjWtCCpPLQ8DA=Gbg_jFneQG539aomZHpm4Oz8WDX7SU3fjQ@mail.gmail.com>
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive dependency
To: David Rientjes <rientjes@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 1:36 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 23 Jan 2014, Ard Biesheuvel wrote:
>
>> The GOOGLE_SMI Kconfig symbol depends on DMI and selects EFI. This
>> causes problems on other archs when introducing DMI support that
>> depends on EFI, as it results in a recursive dependency:
>>
>> arch/arm/Kconfig:1845:error: recursive dependency detected!
>> arch/arm/Kconfig:1845:        symbol DMI depends on EFI
>>
>> Fix by changing the 'select EFI' to a 'depends on EFI'.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Mike Waychison <mikew@google.com>

>> ---
>>  drivers/firmware/google/Kconfig | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
>> index 2f21b0bfe653..29c8cdda82a1 100644
>> --- a/drivers/firmware/google/Kconfig
>> +++ b/drivers/firmware/google/Kconfig
>> @@ -12,8 +12,7 @@ menu "Google Firmware Drivers"
>>
>>  config GOOGLE_SMI
>>       tristate "SMI interface for Google platforms"
>> -     depends on ACPI && DMI
>> -     select EFI
>> +     depends on ACPI && DMI && EFI
>>       select EFI_VARS
>>       help
>>         Say Y here if you want to enable SMI callbacks for Google
>
> Adding Mike Waychison <mikew@google.com> to the cc since this is his code,
> but it looks good to me.
>
> $ ./scripts/get_maintainer.pl -f drivers/firmware/google/Kconfig
> linux-kernel@vger.kernel.org (open list)
>
> I wonder why he's not listed as a recipient for patches from
> get_maintainer.pl since it's clearly obvious he wrote the entire file.
