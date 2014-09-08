Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaIHLD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:03:59 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58656 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaIHLD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:03:57 -0400
Message-ID: <540D8D1F.5000804@linaro.org>
Date: Mon, 08 Sep 2014 12:03:59 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Introduce dummy version of asm/fiq.h
References: <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org> <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org> <1409931198-22600-5-git-send-email-daniel.thompson@linaro.org> <20140905165033.GD10976@arm.com>
In-Reply-To: <20140905165033.GD10976@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/14 17:50, Catalin Marinas wrote:
> On Fri, Sep 05, 2014 at 04:33:17PM +0100, Daniel Thompson wrote:
>> Drivers that are shared between arm and arm64 and which employ
>> FIQ on arm cannot include asm/fiq.h without #ifdef'ing. This patch
>> introduces a dummy version of asm/fiq.h to arm64 to avoid this.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm64/include/asm/fiq.h | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/fiq.h
>>
>> diff --git a/arch/arm64/include/asm/fiq.h b/arch/arm64/include/asm/fiq.h
>> new file mode 100644
>> index 0000000..909ec54
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/fiq.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * arch/arm64/include/asm/fiq.h
>> + *
>> + * Placeholder to reduce #ifdef'ing in shared arm/arm64 drivers.
>> + */
>> +
>> +#ifndef __ASM_FIQ_H
>> +#define __ASM_FIQ_H
>> +
>> +/*
>> + * This placeholder allows code of the following form to be simplified:
>> + *
>> + * #ifdef CONFIG_FIQ
>> + * #include <asm/fiq.h>
>> + * #endif
>> + */
>> +
>> +#endif
> 
> OK, we add a dummy file, but please keep it simple. Comments are fine
> but no need for header guards (nor the file name, on arm64 we try to get
> rid of them, though some still slip through).

Ok. I'll fix this.

