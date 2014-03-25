Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaCYKdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:33:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40608 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaCYKdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:33:46 -0400
Message-ID: <53315B83.2060509@hitachi.com>
Date: Tue, 25 Mar 2014 19:33:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, fche@redhat.com, mingo@redhat.com,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>, systemtap@sourceware.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v8 14/26] x86: Use NOKPROBE_SYMBOL() instead of __kprobes
 annotation
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120021.22766.59.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324154518.77096045@gandalf.local.home>
In-Reply-To: <20140324154518.77096045@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 4:45), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:21 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>   
>>  /*
>>   * This is gone through when something in the kernel has done something bad
>> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
>> index ae5aafb..d00103a 100644
>> --- a/arch/x86/kernel/kprobes/core.c
>> +++ b/arch/x86/kernel/kprobes/core.c
>> @@ -112,7 +112,8 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
>>  
>>  const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
>>  
>> -static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
>> +static nokprobe_inline
>> +void __synthesize_relative_insn(void *from, void *to, u8 op)
> 
> I believe the proper way to break this up is:
> 
> static nokprobe_inline void
> __synthesize_relative_insn(...)

Oops, there are so many incorrect style hunks...:( I'll fix those.

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


