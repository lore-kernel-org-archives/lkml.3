Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3F1A24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:28:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17134 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab3F1A2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:28:55 -0400
X-Spam-Score: -100.9
Message-ID: <51CCD891.8000806@asianux.com>
Date: Fri, 28 Jun 2013 08:28:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] tile: include: asm: missing "feedback.h" file.
References: <51CA6D21.3090901@asianux.com> <51CC492C.1040105@tilera.com>
In-Reply-To: <51CC492C.1040105@tilera.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 10:16 PM, Chris Metcalf wrote:
> On 6/26/2013 12:25 AM, Chen Gang wrote:
>> > Hello Maintainers:
>> >
>> > The compilation failed by "make ARCH=tile tilegx_defconfig", and "make
>> > ARCH=tile CROSS_COMPILE=tile-linux-gnu-" for upstream next-20130625.
>> >
>> > The related error:
>> >
>> >     CC      kernel/bounds.s
>> >   In file included from include/linux/linkage.h:7:0,
>> >                    from include/linux/kernel.h:6,
>> >                    from include/asm-generic/bug.h:13,
>> >                    from arch/tile/include/generated/asm/bug.h:1,
>> >                    from include/linux/bug.h:4,
>> >                    from include/linux/page-flags.h:9,
>> >                    from kernel/bounds.c:9:
>> >   /root/linux-next/arch/tile/include/asm/linkage.h:18:22: fatal error: feedback.h: No such file or directory
>> >
>> > We really need "feedback.h"
>> >
>> >   arch/tile/kernel/entry.S: Assembler messages:
>> >   arch/tile/kernel/entry.S:26: Error: Unknown opcode `feedback_enter(current_text_addr)'.
>> >   arch/tile/kernel/entry.S:46: Error: Unknown opcode `feedback_enter(dump_stack)'.
>> >   arch/tile/kernel/entry.S:53: Error: Unknown opcode `feedback_enter(KBacktraceIterator_init_current)'.
>> >   arch/tile/kernel/entry.S:61: Error: Unknown opcode `feedback_enter(smp_nap)'.
>> >   arch/tile/kernel/entry.S:76: Error: Unknown opcode `feedback_enter(_cpu_idle)'.
>> >
>> > Welcome any suggestions and completions.
> This is fixed in gcc 4.7.2 or later.  For the workaround, see:
> 
> http://www.tilera.com/scm/source.html#feedback_h
> 

Thank you very much.

> Essentially, you just have to create a dummy <feedback.h> header, e.g. for 4.7.1:
> 
>   cat > $install/lib/gcc/tilegx-unknown-linux-gnu/4.7.1/include/feedback.h
>   #define FEEDBACK_ENTER_EXPLICIT(FUNCNAME, SECNAME, SIZE)
>   #define FEEDBACK_ENTER(FUNCNAME)
>   #define FEEDBACK_REENTER(FUNCNAME)
>   #define FEEDBACK_ENTRY(FUNCNAME, SECNAME, SIZE)
>   ^D

I should try as soon as possible.

Thanks again.
-- 
Chen Gang
