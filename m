Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbaAJPtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:49:49 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:51716 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAJPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:49:46 -0500
MIME-Version: 1.0
In-Reply-To: <1387815579-15677-4-git-send-email-taras.kondratiuk@linaro.org>
References: <1387815579-15677-1-git-send-email-taras.kondratiuk@linaro.org>
	<1387815579-15677-4-git-send-email-taras.kondratiuk@linaro.org>
Date: Fri, 10 Jan 2014 17:49:44 +0200
Message-ID: <CAArO44uuHoTjb9TJAXJLmp88GeY+kEGp+nom8LMt8-KoF0isYQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: kprobes-test: use <asm/opcodes.h> for ARM
 instruction building
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Jon Medhurst <tixy@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Victor Kamensky <victor.kamensky@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 18:19, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
> From: Ben Dooks <ben.dooks@codethink.co.uk>
>
> The kprobes test will build certain instructions incorrectly if building
> big endian as .word output gets endian-swapped by the linker. Change to
> using <asm/opcodes.h> and __inst_arm() to produce instructions.
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> [taras.kondratiuk@linaro.org: fixed a few missed instructions]
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
>  arch/arm/kernel/kprobes-test-arm.c |  595 ++++++++++++++++++------------------
>  1 file changed, 298 insertions(+), 297 deletions(-)
>
> diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
> index 8393129..56be041 100644
> --- a/arch/arm/kernel/kprobes-test-arm.c
> +++ b/arch/arm/kernel/kprobes-test-arm.c

[snip]

> @@ -1180,43 +1181,43 @@ void kprobe_arm_test_cases(void)
>                                                                                 \
>         TEST_COPROCESSOR( "stc"two"     0, cr0, [r15, #4]")                     \
>         TEST_COPROCESSOR( "stc"two"     0, cr0, [r15, #-4]")                    \
> -       TEST_UNSUPPORTED(".word 0x"cc"daf0001   @ stc"two"      0, cr0, [r15, #4]!")    \
> -       TEST_UNSUPPORTED(".word 0x"cc"d2f0001   @ stc"two"      0, cr0, [r15, #-4]!")   \
> -       TEST_UNSUPPORTED(".word 0x"cc"caf0001   @ stc"two"      0, cr0, [r15], #4")     \
> -       TEST_UNSUPPORTED(".word 0x"cc"c2f0001   @ stc"two"      0, cr0, [r15], #-4")    \
> +       TEST_UNSUPPORTED(__inst_arm(0x##ccdaf0001) "    @ stc"two"      0, cr0, [r15, #4]!")    \
> +       TEST_UNSUPPORTED(__inst_arm(0x##ccd2f0001) "    @ stc"two"      0, cr0, [r15, #-4]!")   \
> +       TEST_UNSUPPORTED(__inst_arm(0x##cccaf0001) "    @ stc"two"      0, cr0, [r15], #4")     \
> +       TEST_UNSUPPORTED(__inst_arm(0x##ccc2f0001) "    @ stc"two"      0, cr0, [r15], #-4")    \

Oops. Should be something like __inst_arm(0x##cc##c2f0001).
My compiler truncated it to 32 bits, so these tests passed anyway.
I'll repost a fixed series.

-- 
Regards,
Taras Kondratiuk
