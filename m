Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3F0OQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:16:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13224 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3F0OQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:16:16 -0400
Message-ID: <51CC492C.1040105@tilera.com>
Date: Thu, 27 Jun 2013 10:16:12 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] tile: include: asm: missing "feedback.h" file.
References: <51CA6D21.3090901@asianux.com>
In-Reply-To: <51CA6D21.3090901@asianux.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2013 12:25 AM, Chen Gang wrote:
> Hello Maintainers:
>
> The compilation failed by "make ARCH=tile tilegx_defconfig", and "make
> ARCH=tile CROSS_COMPILE=tile-linux-gnu-" for upstream next-20130625.
>
> The related error:
>
>     CC      kernel/bounds.s
>   In file included from include/linux/linkage.h:7:0,
>                    from include/linux/kernel.h:6,
>                    from include/asm-generic/bug.h:13,
>                    from arch/tile/include/generated/asm/bug.h:1,
>                    from include/linux/bug.h:4,
>                    from include/linux/page-flags.h:9,
>                    from kernel/bounds.c:9:
>   /root/linux-next/arch/tile/include/asm/linkage.h:18:22: fatal error: feedback.h: No such file or directory
>
> We really need "feedback.h"
>
>   arch/tile/kernel/entry.S: Assembler messages:
>   arch/tile/kernel/entry.S:26: Error: Unknown opcode `feedback_enter(current_text_addr)'.
>   arch/tile/kernel/entry.S:46: Error: Unknown opcode `feedback_enter(dump_stack)'.
>   arch/tile/kernel/entry.S:53: Error: Unknown opcode `feedback_enter(KBacktraceIterator_init_current)'.
>   arch/tile/kernel/entry.S:61: Error: Unknown opcode `feedback_enter(smp_nap)'.
>   arch/tile/kernel/entry.S:76: Error: Unknown opcode `feedback_enter(_cpu_idle)'.
>
> Welcome any suggestions and completions.

This is fixed in gcc 4.7.2 or later.  For the workaround, see:

http://www.tilera.com/scm/source.html#feedback_h

Essentially, you just have to create a dummy <feedback.h> header, e.g. for 4.7.1:

  cat > $install/lib/gcc/tilegx-unknown-linux-gnu/4.7.1/include/feedback.h
  #define FEEDBACK_ENTER_EXPLICIT(FUNCNAME, SECNAME, SIZE)
  #define FEEDBACK_ENTER(FUNCNAME)
  #define FEEDBACK_REENTER(FUNCNAME)
  #define FEEDBACK_ENTRY(FUNCNAME, SECNAME, SIZE)
  ^D

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

