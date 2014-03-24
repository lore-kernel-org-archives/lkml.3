Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaCXBKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:10:24 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43041 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaCXBKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:10:23 -0400
Message-ID: <532F85F8.9030803@hitachi.com>
Date: Mon, 24 Mar 2014 10:10:16 +0900
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
Subject: Re: Re: [PATCH -tip v8 01/26] [BUGFIX]kprobes/x86: Fix page-fault
 handling logic
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115850.22766.13456.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321173922.76348fdd@gandalf.local.home>
In-Reply-To: <20140321173922.76348fdd@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 6:39), Steven Rostedt wrote:
>> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
>> index 79a3f96..b482e96 100644
>> --- a/arch/x86/kernel/kprobes/core.c
>> +++ b/arch/x86/kernel/kprobes/core.c
>> @@ -897,9 +897,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
>>  	struct kprobe *cur = kprobe_running();
>>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
>>  
>> -	switch (kcb->kprobe_status) {
>> -	case KPROBE_HIT_SS:
>> -	case KPROBE_REENTER:
>> +	if (unlikely(regs->ip == (unsigned long)cur->ainsn.insn)) {
> 
> I wonder if we should add a:
> 
> 	WARN_ON(kcb->kprobe_status != KPROBE_HIT_SS &&
> 		kcb->kprobe_status != KPROBE_REENTER);

Ah, right. I'll add it for verifying the status.

Thanks!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


