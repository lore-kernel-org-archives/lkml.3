Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3HZLHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:07:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28581 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3HZLHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:07:07 -0400
X-Spam-Score: -101.0
Message-ID: <521B369B.4010602@asianux.com>
Date: Mon, 26 Aug 2013 19:06:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300/kernel/setup.c: add "linux/initrd.h" to pass compiling
References: <521B2E75.1040802@asianux.com> <CAMuHMdVXJvLfmNLFFW=TBLOi2_mVyZy+kr46oM5GVz_PK-bbvA@mail.gmail.com>
In-Reply-To: <CAMuHMdVXJvLfmNLFFW=TBLOi2_mVyZy+kr46oM5GVz_PK-bbvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 07:00 PM, Geert Uytterhoeven wrote:
> On Mon, Aug 26, 2013 at 12:31 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> --- a/arch/h8300/kernel/setup.c
>> +++ b/arch/h8300/kernel/setup.c
>> @@ -47,6 +47,9 @@
>>  #include <asm/regs267x.h>
>>  #endif
>>
>> +#if defined(CONFIG_BLK_DEV_INITRD)
> 
> Why have you added the #ifdef?
> 

The related code is below (maybe we need add additional related
comments in the patch for it ?).

in arch/h8300/kernel/setup.c

 94 void __init setup_arch(char **cmdline_p)
 95 {
 96         int bootmap_size;
 97 
 98         memory_start = (unsigned long) &_ramstart;
 99 
100         /* allow for ROMFS on the end of the kernel */
101         if (memcmp((void *)memory_start, "-rom1fs-", 8) == 0) {
102 #if defined(CONFIG_BLK_DEV_INITRD)
103                 initrd_start = memory_start;
104                 initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
105 #else
106                 memory_start += be32_to_cpu(((unsigned long *) memory_start)[2]);
107 #endif
108         }


>> +#include <linux/initrd.h>
>> +#endif
>>  #define STUBSIZE 0xc000
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
> 


-- 
Chen Gang
