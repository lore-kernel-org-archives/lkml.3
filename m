Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KGJAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:00:07 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57758 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3KGJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:00:03 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-7c-527b5690b2cb
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
	<20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com>
	<20131106173754.GA11299@redhat.com>
	<20131106182408.GA12922@redhat.com>
Date: Thu, 07 Nov 2013 18:00:00 +0900
In-Reply-To: <20131106182408.GA12922@redhat.com> (Oleg Nesterov's message of
	"Wed, 6 Nov 2013 19:24:08 +0100")
Message-ID: <8761s4wprj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 19:24:08 +0100, Oleg Nesterov wrote:
> Forgot to mention,
>
> On 11/06, Oleg Nesterov wrote:
>>
>> I meant,
>>
>> 		saved_ip = instruction_pointer(regs);
>>
>> 		// pass the "ip" which was used to calculate
>> 		// the @addr argument to fetch_*() methods
>>
>> 		temp_ip = is_ret_probe(tu) ? func : saved_ip;
>> 		temp_ip -= tu->offset;
>> 		instruction_pointer_set(temp_ip);
>>
>> 		store_trace_args(...);
>
> Note that instruction_pointer_set() is not really nice in any case,
> this can obviously confuse FETCH_MTD_reg("ip").

Yes.

>
> But lets ignore this. The solution is simple, we can pass/use this
> info via current->utask. We can either add the new member, or add
> a union. Or simply reuse xol_vaddr. Doesn't matter.

Okay, I'll take a look.

>
> So the only question is should we rely on instruction_pointer/func
> to translate the address or we should do something else (say, vma).
>
> So far I like this approach.

Me too. :)

So, I'll wait for more feedbacks from others and then send a new
version.  Actually I don't have much to do this these days - probably
until next week (there'll be the KLF).  Please forgive my brevity in
replies.

I'll be back with a new patchset then. :)

Thanks,
Namhyung
