Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaEWMGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:06:04 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62422 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaEWMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:06:01 -0400
Message-ID: <537F39D7.6090309@linaro.org>
Date: Fri, 23 May 2014 14:06:47 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/7] acpi, apei, ghes: Factor out NMI error notification
 context.
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org> <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org> <20140513194125.GD8760@pd.tnic>
In-Reply-To: <20140513194125.GD8760@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.05.2014 21:41, Borislav Petkov wrote:
> On Wed, Apr 09, 2014 at 05:14:32PM +0200, Tomasz Nowicki wrote:
>> Use CONFIG_ACPI_APEI_NMI to isolate NMI error notification path. NMI related
>> data and functions are grouped so they can be wrapped inside one
I have missed end of sentence. I should goes like that:

Use CONFIG_ACPI_APEI_NMI to isolate NMI error notification path. NMI 
related data and functions are grouped so they can be wrapped inside one
#ifdefs CONFIG_ACPI_APEI_NMI.

>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/apei/ghes.c |   54 +++++++++++++++++++++++++---------------------
>>   1 file changed, 30 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index ca8387e..7a0d66e 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -53,7 +53,9 @@
>>   #include <asm/mce.h>
>>   #endif
>>   #include <asm/tlbflush.h>
>> +#ifdef CONFIG_ACPI_APEI_NMI
>>   #include <asm/nmi.h>
>> +#endif
>
> This, again, can be avoided with adding arch-specific versions and empty
> default stubs.
>

I had that thoughts too. Looking at simple MCE calls, yes, it does make 
sense to create corresponding arch-specific version and provide logic as 
needed. I think that NMI is much more complicated. NMI context is 
tightly coupled with the rest of GHES mechanisms like pool memory, list 
locks etc. which are GHES locally available. I am not saying it is 
impossible, I am just concerned if it makes sense to create e.g. 
apei-nmi.c arch-specific file and export necessary GHES mechanisms just 
for NMI purpose. Please let me know your opinion on this.

Regards,
Tomasz
