Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaCXBsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:48:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52812 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaCXBsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:48:08 -0400
Message-ID: <532F8ED2.2030704@hitachi.com>
Date: Mon, 24 Mar 2014 10:48:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH -tip v8 03/26] kprobes: Prohibit probing on .entry.text
 code
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115904.22766.57607.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321180400.0c1b2969@gandalf.local.home>
In-Reply-To: <20140321180400.0c1b2969@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 7:04), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:04 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>  struct kprobe_insn_cache {
>>  	struct mutex mutex;
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index ceeadfc..5b5ac76 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -96,9 +96,6 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>>  static struct kprobe_blackpoint kprobe_blacklist[] = {
>>  	{"preempt_schedule",},
>>  	{"native_get_debugreg",},
>> -	{"irq_entries_start",},
>> -	{"common_interrupt",},
>> -	{"mcount",},	/* mcount can be called from everywhere */
> 
> Is mcount in the entry.text section? Also, what about ftrace_caller and
> friends.

I saw mcount(and ftrace_caller) in arch/x86/kernel/entry_*.S, and
almost all code in it are in ".entry.text" section as far as I can see,
or do I miss something?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


