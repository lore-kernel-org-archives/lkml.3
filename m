Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaCVS4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:56:09 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52526 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCVS4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKjt3oBxeHPdDjUGoH+JMma21rbgFjUab62yCXtck_SZA@mail.gmail.com>
References: <20140322151657.GA23606@www.outflux.net>
	<CAL_JsqKjt3oBxeHPdDjUGoH+JMma21rbgFjUab62yCXtck_SZA@mail.gmail.com>
Date: Sat, 22 Mar 2014 12:56:03 -0600
X-Google-Sender-Auth: qIsqjV5fMejIH-mHvRkSLyWj5NE
Message-ID: <CAGXu5j+PZ8yX1=btQTwt58maQKTRWWuqnmMNhwzG7Y1fuRJ9qA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: mm: fix reporting of read-only PMD bits
From: Kees Cook <keescook@chromium.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 10:45 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Sat, Mar 22, 2014 at 10:16 AM, Kees Cook <keescook@chromium.org> wrote:
>> On non-LPAE ARMv6+, read-only PMD bits are defined with the combination
>> "PMD_SECT_APX | PMD_SECT_AP_WRITE". Adjusted the bit masks to correctly
>> report this.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v3:
>>  - check for pre-v6 CPUs on the page table report.
>> v2:
>>  - reorder bits, suggested by Olof.
>> ---
>>  arch/arm/mm/dump.c |   31 +++++++++++++++++++++++++------
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
>> index ef69152f9b52..c1122d266c45 100644
>> --- a/arch/arm/mm/dump.c
>> +++ b/arch/arm/mm/dump.c
>> @@ -121,23 +121,42 @@ static const struct prot_bits pte_bits[] = {
>>
>>  static const struct prot_bits section_bits[] = {
>>  #ifndef CONFIG_ARM_LPAE
>> -       /* These are approximate */
>> +# if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V6K) || defined(CONFIG_CPU_V7)
>
> You can simplify the ifdef logic like this:
>
> #ifdef CONFIG_ARM_LPAE /* Implies v7 */
>
> #elif __LINUX_ARM_ARCH__ >= 6
>
> #else
> /* v4/v5 */
> #endif

Ah! Perfect, thanks! I'll resend it this way.

-Kees

-- 
Kees Cook
Chrome OS Security
