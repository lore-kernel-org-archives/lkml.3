Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaCXDEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:04:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43809 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCXDEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:04:05 -0400
Message-ID: <532FA09D.1040405@hitachi.com>
Date: Mon, 24 Mar 2014 12:03:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 07/26] [BUGFIX] x86: Prohibit probing on thunk
 functions and restore
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115932.22766.76074.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321210020.438f6e32@gandalf.local.home>
In-Reply-To: <20140321210020.438f6e32@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 10:00), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:32 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>  	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
>> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
>> index a63efd6..92d9fea 100644
>> --- a/arch/x86/lib/thunk_64.S
>> +++ b/arch/x86/lib/thunk_64.S
>> @@ -8,6 +8,7 @@
>>  #include <linux/linkage.h>
>>  #include <asm/dwarf2.h>
>>  #include <asm/calling.h>
>> +#include <asm/asm.h>
>>  
>>  	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
>>  	.macro THUNK name, func, put_ret_addr_in_rdi=0
>> @@ -25,6 +26,7 @@
>>  	call \func
>>  	jmp  restore
>>  	CFI_ENDPROC
>> +	_ASM_NOKPROBE(\name)
>>  	.endm
>>  
>>  #ifdef CONFIG_TRACE_IRQFLAGS
>> @@ -43,3 +45,4 @@ restore:
>>  	RESTORE_ARGS
>>  	ret
>>  	CFI_ENDPROC
>> +	_ASM_NOKPROBE(restore)
>>
> 
> Does kallsyms return something for this? I'm curious to what it does.
> It might find something that we didn't expect. Do you have debug code
> to list out all the black listed items found at boot up?

Yes, with [19/26] the blacklisted functions are shown in debugfs
(kprobes/blacklist) :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


