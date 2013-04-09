Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899Ab3DIMPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:15:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57885 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935726Ab3DIMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <m2ip48d62f.fsf@igel.home>
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
 <1363949290.3528.37.camel@linaro1.home> <m2ip48d62f.fsf@igel.home>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 9 Apr 2013 17:44:47 +0530
Message-ID: <CA+V-a8srtwdf1H2JQwbkyMFhXopPEA90RM8Hy+UunM6Mm7-d1w@mail.gmail.com>
Subject: Re: [BUG] mod/file2alias: build error in devicetable-offsets.c [was:
 asm/types.h Header file wont get generated while building uImage ?]
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas

On Sun, Mar 31, 2013 at 1:16 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> "Jon Medhurst (Tixy)" <tixy@linaro.org> writes:
>
>> For builds which succeed I see this order:
>>
>>   WRAP    arch/arm/include/generated/asm/types.h
>>   [...]
>>   GEN     include/generated/asm-offsets.h
>>
>> and for those which fail:
>>
>>   CC      scripts/mod/devicetable-offsets.s
>>   In file included from include/linux/types.h:5:0,
>>                    from include/linux/mod_devicetable.h:11,
>>                    from scripts/mod/devicetable-offsets.c:2:
>>   include/uapi/linux/types.h:4:23: fatal error: asm/types.h: No such file or directory
>>   [...]
>>   WRAP    arch/arm/include/generated/asm/types.h
>
> Does that help?
>
> diff --git a/Makefile b/Makefile
> index a5f3203..2a484db 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -512,7 +512,8 @@ ifeq ($(KBUILD_EXTMOD),)
>  # Carefully list dependencies so we do not try to build scripts twice
>  # in parallel
>  PHONY += scripts
> -scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
> +scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
> +        asm-generic
>         $(Q)$(MAKE) $(build)=$(@)
>
>  # Objects we will link into vmlinux / subdirs we need to visit
>
Whats the status of it ?

Regards,
--Prabhakar

> Andreas.
>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
