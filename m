Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3LJIys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:54:48 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36324 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3LJIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:54:46 -0500
Message-ID: <52A6D6DD.50702@hitachi.com>
Date: Tue, 10 Dec 2013 17:54:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH -tip v5 12/18] ftrace/kprobes: Use NOKPROBE_SYMBOL
 macro in ftrace
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal> <20131209104746.13397.22146.stgit@kbuild-fedora.novalocal> <20131209120450.4da43296@gandalf.local.home>
In-Reply-To: <20131209120450.4da43296@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/10 2:04), Steven Rostedt wrote:
> On Mon, 09 Dec 2013 10:47:46 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> --- a/kernel/trace/trace_probe.h
>> +++ b/kernel/trace/trace_probe.h
>> @@ -124,8 +124,8 @@ struct probe_arg {
>>  	const struct fetch_type	*type;	/* Type of this argument */
>>  };
>>  
>> -static inline __kprobes void call_fetch(struct fetch_param *fprm,
>> -				 struct pt_regs *regs, void *dest)
>> +static inline void call_fetch(struct fetch_param *fprm,
>> +			      struct pt_regs *regs, void *dest)
>>  {
>>  	return fprm->fn(regs, fprm->data, dest);
>>  }
>>
> 
> Is this OK to be probed? I've had cases where a header "static inline"
> was not always inlined. Unless you have "__always_inline" this is not
> guaranteed to be inlined.

Ah, right! I need to change it to __always_inline to prevent
probing on it.

> 
> As for the rest of the patch:
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thank you! :)


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


