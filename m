Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3KFI51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:57:27 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47023 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:57:25 -0500
X-AuditID: 9c93016f-b7bb9ae000001e30-5e-527a04741109
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
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
	<20131105192401.GA772@redhat.com>
Date: Wed, 06 Nov 2013 17:57:24 +0900
In-Reply-To: <20131105192401.GA772@redhat.com> (Oleg Nesterov's message of
	"Tue, 5 Nov 2013 20:24:01 +0100")
Message-ID: <87vc05x5zf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 20:24:01 +0100, Oleg Nesterov wrote:
> On 11/05, Oleg Nesterov wrote:
>>
>> As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
>> the "@" argument anyway, why it can't also substruct this offset?
>>
>> Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
>> in this case it needs another argument, not sure...
>
> Or,
>
>> 	+	if (is_ret_probe(tu)) {
>> 	+		saved_ip = instruction_pointer(regs);
>> 	+		instruction_pointer_set(func);
>> 	+	}
>> 		store_trace_args(...);
>> 	+	if (is_ret_probe(tu))
>> 	+		instruction_pointer_set(saved_ip);
>
> we can put "-= tu->offset" here.

I don't think I get the point.

>
> Or. Perhaps we can leave "case '@'" in parse_probe_arg() and
> FETCH_MTD_memory alone. You seem to agree that "absolute address"
> can be useful anyway.

Yes, but it's only meaningful to process-wide tracing sessions IMHO.

>
> Instead, perhaps we can add FETCH_MTD_memory_do_fancy_addr_translation,
> and, say, the new "case '*'" in parse_probe_arg() should add all the
> neccessary info as f->data (like, say, FETCH_MTD_symbol).

Could you elaborate this more?

>
> But, just in case, I do not have a strong opinion. Just I think it
> is better to discuss every choice we have.

Okay.  I really appreciate your reviews.


Thanks,
Namhyung
