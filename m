Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaGWHki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:40:38 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:48099 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbaGWHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:40:36 -0400
Message-ID: <53CF66FC.1040604@linaro.org>
Date: Wed, 23 Jul 2014 09:40:44 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Borislav Petkov <bp@suse.de>, rric@kernel.org,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v5 0/3] APEI: Make APEI architecture independent.
References: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org> <CA+8MBb+KuKaeXr5p97xWZKJB7T-NAooi-kXQTaPx0QnO53-oCQ@mail.gmail.com>
In-Reply-To: <CA+8MBb+KuKaeXr5p97xWZKJB7T-NAooi-kXQTaPx0QnO53-oCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks Tony! And thanks goes to Borislav and Robert too.

Regards,
Tomasz

On 22.07.2014 23:08, Tony Luck wrote:
> On Tue, Jul 22, 2014 at 2:20 AM, Tomasz Nowicki
> <tomasz.nowicki@linaro.org> wrote:
>> APEI is currently implemented so that it depends on x86 hardware.
>> The primary dependency is that GHES uses the x86 NMI for hardware
>> error notification and MCE for memory error handling. These patches
>> remove that dependency.
>>
>> Other APEI features such as error reporting via external IRQ, error
>> serialization, or error injection, do not require changes to use them
>> on non-x86 architectures.
>>
>> The following patch set eliminates the APEI Kconfig x86 dependency
>> by making these changes:
>> - treat NMI notification as GHES architecture - HAVE_ACPI_APEI_NMI
>> - group and wrap around #ifdef CONFIG_HAVE_ACPI_APEI_NMI code which
>>    is used only for NMI path
>> - identify architectural boxes and abstract it accordingly (tlb flush and MCE)
>> - rework ioremap for both IRQ and NMI context
>>
>> NMI code is kept in ghes.c file since NMI and IRQ context are tightly coupled.
>>
>> Note, these patches introduce no functional changes for x86. The NMI notification
>> feature is hard selected for x86. Architectures that want to use this
>> feature should also provide NMI code infrastructure.
>
> Looks OK to me. I've thrown this series into a topic branch of the ras
> git tree named "apei".  When I push it to kernel.org in a few minutes
> the build test robots will pounce and try all sorts of randconfig builds.
> They'll send you (and me) e-mails if they find any corner cases.
>
> -Tony
>
