Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaIDHuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:50:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbaIDHuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:50:08 -0400
Message-ID: <540819A8.7060205@canonical.com>
Date: Thu, 04 Sep 2014 09:50:00 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com> <20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com> <5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com> <54073409.6030004@canonical.com> <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com> <20140903175948.GH3001@console-pimps.org> <54078C74.2060804@zytor.com> <CAKv+Gu8VkW+unei3vGZxor6ZGuLwsmKktcBJfy3+bKrkrKgPyw@mail.gmail.com> <20140904074008.GJ3001@console-pimps.org>
In-Reply-To: <20140904074008.GJ3001@console-pimps.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 04-09-14 om 09:40 schreef Matt Fleming:
> On Thu, 04 Sep, at 08:47:57AM, Ard Biesheuvel wrote:
>> So how about we:
>> - add ASSERT(_got == _egot, "GOT entries not supported in
>> boot/compressed") to the linker script
>> - #define __nogotentry __attribute__((visibility(hidden))) somewhere
>> in compiler.h or wherever else it belongs
>> - add the __nogotentry qualifiers to each extern that requires it,
>> which is currently:
>> early_serial_base
>> efi_early
>> free_mem_end_ptr
>> free_mem_ptr
>> real_mode
>> - get rid of the fixup code in assembly
>  
> Seems fine to me since it was Peter who introduced the GOT fixup asm
> code in the first place.
>
>> Any idea what the oldest GCC is we should support?
> I'm pretty sure we still support GCC 3.x.x. The symbol visibility
> support was added in GCC 4.x right?
>
gcc 3.3.6 has documented visibility at least.

https://gcc.gnu.org/onlinedocs/gcc-3.3.6/gcc/Function-Attributes.html#Function-Attributes

I couldn't find it in earlier manuals, but grepping through gcc 3.0.4 source code shows that it would appear to be supported there too.

~Maarten

