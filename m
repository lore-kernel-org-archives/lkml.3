Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaDYKMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:12:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41946 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaDYKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:12:09 -0400
Message-ID: <535A34F1.3000106@hitachi.com>
Date: Fri, 25 Apr 2014 19:12:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Jason Baron <jbaron@akamai.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, Rob Landley <rob@landley.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, systemtap@sourceware.org
Subject: Re: [PATCH -tip v9 20/26] kprobes: Support blacklist functions in
 module
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140417081856.26341.53535.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140424085601.GA7768@gmail.com> <5358F458.1030300@hitachi.com> <20140425081951.GA24829@gmail.com>
In-Reply-To: <20140425081951.GA24829@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/25 17:19), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/04/24 17:56), Ingo Molnar wrote:
>>>> diff --git a/include/linux/module.h b/include/linux/module.h
>>>> index f520a76..2fdb673 100644
>>>> --- a/include/linux/module.h
>>>> +++ b/include/linux/module.h
>>>> @@ -16,6 +16,7 @@
>>>>  #include <linux/kobject.h>
>>>>  #include <linux/moduleparam.h>
>>>>  #include <linux/jump_label.h>
>>>> +#include <linux/kprobes.h>
>>>
>>> This include breaks the x86 build:
>>>
>>>   CC      arch/x86/kernel/jump_label.o
>>>   In file included from arch/x86/kernel/jump_label.c:14:0:
>>>   /fast/mingo/tip/arch/x86/include/asm/kprobes.h:35:12: error: conflicting types for ‘kprobe_opcode_t' typedef u8 kprobe_opcode_t;
>>>   [...]
>>
>> Hmm, this error seems very odd... and I don't see
> 
> Needs 'make allnoconfig' or some similar .config combination.

Ah, OK. I could reproduce it. And as far as I can see, this is jump_label's bug.
jump_label.c includes asm/kprobes.h directly, but that header is for internal use.
It has to include linux/kprobes.h instead. Moreover, it doesn't need kprobes.h anymore.

I'll fix that by another patch.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


