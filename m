Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3FRBbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:31:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43053 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3FRBbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:31:41 -0400
Message-ID: <51BFB878.10508@hitachi.com>
Date: Tue, 18 Jun 2013 10:31:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
 multibuffer
References: <51BA7578.4080108@huawei.com> <51BB18EB.9080307@hitachi.com>  <1371223918.9844.324.camel@gandalf.local.home>  <20130614162112.GO5146@linux.vnet.ibm.com>  <1371227607.9844.335.camel@gandalf.local.home>  <20130614172516.GP5146@linux.vnet.ibm.com> <51BE7A83.9060802@hitachi.com> <1371472393.18733.5.camel@gandalf.local.home>
In-Reply-To: <1371472393.18733.5.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/17 21:33), Steven Rostedt wrote:
> On Mon, 2013-06-17 at 11:54 +0900, Masami Hiramatsu wrote:
> 
>>> It makes a lot of sense to me, at least assuming no issues with the
>>> interrupts being disabled, but the checks not spotting this.  Here
>>> is the check:
>>>
>>> 	preempt_count() != 0 || irqs_disabled()
>>>
>>> (With additional elaboration for if lockdep is enabled.)
>>
>> OK, I see. So I'll convert all the rcu_dereference_raw() to
>> rcu_dereference_sched() except kprobe handler, because in the
>> kprobe handler above check always be true. :)
> 
> I would convert them all to rcu_dereference_sched(), the above check is
> only when CONFIG_DEBUG_LOCK_ALLOC is set. It also annotates what is
> protecting this variable. Please do not avoid a check because "it's
> always true here". You also get people copying that code (like for
> uprobes) and that will skip the check too.
> 
> The only reason ftrace function tracer uses the raw (and now
> raw_notrace) version is because it is extremely invasive, and these
> checks done at *every* function call can actually live lock the system.
> But other places in tracing use the appropriate rcu_dereference_*()
> functions. If they do not, then they need to be fixed too.

Oh, I see.
Anyway, it will be completely replaced by the Oleg's patch.
Or should I fix that before his work?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


