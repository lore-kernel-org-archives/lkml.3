Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaCYKbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:31:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56579 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaCYKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:31:45 -0400
Message-ID: <53315B0A.3000607@hitachi.com>
Date: Tue, 25 Mar 2014 19:31:38 +0900
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
Subject: Re: [PATCH -tip v8 16/26] ftrace/kprobes: Use NOKPROBE_SYMBOL macro
 in ftrace
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120035.22766.90265.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324161025.3f51bab6@gandalf.local.home>
In-Reply-To: <20140324161025.3f51bab6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 5:10), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:35 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>   
>> -static __kprobes
>> +static
>>  int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
> 
> again, static and int should be on the same line.

OK, thank you! :)

> 
>>  {
>>  	struct trace_kprobe *tk = container_of(ri->rp, struct trace_kprobe, rp);
>> @@ -1268,6 +1279,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>>  #endif
>>  	return 0;	/* We don't tweek kernel, so just return 0 */
>>  }
>> +NOKPROBE_SYMBOL(kretprobe_dispatcher);
>>  
>>  static struct trace_event_functions kretprobe_funcs = {
>>  	.trace		= print_kretprobe_event
> 
> -- Steve
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


