Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3KETWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:22:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab3KETWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:41 -0500
Date: Tue, 5 Nov 2013 20:24:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131105192401.GA772@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105174535.GA6385@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Oleg Nesterov wrote:
>
> As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
> the "@" argument anyway, why it can't also substruct this offset?
>
> Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
> in this case it needs another argument, not sure...

Or,

> 	+	if (is_ret_probe(tu)) {
> 	+		saved_ip = instruction_pointer(regs);
> 	+		instruction_pointer_set(func);
> 	+	}
> 		store_trace_args(...);
> 	+	if (is_ret_probe(tu))
> 	+		instruction_pointer_set(saved_ip);

we can put "-= tu->offset" here.

> although not pretty.

Yes.

Or. Perhaps we can leave "case '@'" in parse_probe_arg() and
FETCH_MTD_memory alone. You seem to agree that "absolute address"
can be useful anyway.

Instead, perhaps we can add FETCH_MTD_memory_do_fancy_addr_translation,
and, say, the new "case '*'" in parse_probe_arg() should add all the
neccessary info as f->data (like, say, FETCH_MTD_symbol).

But, just in case, I do not have a strong opinion. Just I think it
is better to discuss every choice we have.

Oleg.

