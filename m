Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaJIC0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:26:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37175 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJIC0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:26:07 -0400
Message-ID: <5435F232.6020406@linaro.org>
Date: Thu, 09 Oct 2014 11:25:54 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 5/6] arm64: add SIGSYS siginfo for compat task
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org> <1412243176-16192-6-git-send-email-takahiro.akashi@linaro.org> <20141008143059.GS26140@arm.com>
In-Reply-To: <20141008143059.GS26140@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 11:30 PM, Will Deacon wrote:
> On Thu, Oct 02, 2014 at 10:46:15AM +0100, AKASHI Takahiro wrote:
>> SIGSYS is primarily used in secure computing to notify tracer.
>> This patch allows signal handler on compat task to get correct information
>> with SA_SIGINFO specified when this signal is delivered.
>>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/include/asm/compat.h |    7 +++++++
>>   arch/arm64/kernel/signal32.c    |    6 ++++++
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
>> index 253e33b..c877915 100644
>> --- a/arch/arm64/include/asm/compat.h
>> +++ b/arch/arm64/include/asm/compat.h
>> @@ -205,6 +205,13 @@ typedef struct compat_siginfo {
>>   			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
>>   			int _fd;
>>   		} _sigpoll;
>> +
>> +		/* SIGSYS */
>> +		struct {
>> +			compat_uptr_t _call_addr; /* calling user insn */
>> +			int _syscall;	/* triggering system call number */
>> +			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
>
> nit, but compat_uint_t looks better here (I have no idea why I didn't do
> this for the signed int types, but hey).

I will fix it.

-Takahiro AKASHI

> Will
>
