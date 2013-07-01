Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3GAVOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab3GAVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:14:43 -0400
Date: Mon, 1 Jul 2013 23:10:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130701211003.GA2147@redhat.com>
References: <51CE920C.5020001@huawei.com> <20130701202722.GA413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701202722.GA413@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Oleg Nesterov wrote:
>
> On 06/29, zhangwei(Jovi) wrote:
> >
> > [v3->v4]:
>
> I am wondering how much you will hate me if I suggest to make v5 ;)
>
> But look, imho probe_event_enable() looks a bit more confusing than
> it needs.

And I am a bit worried this patch removes the is_trace_uprobe_enabled()
check from probe_event_enable()...

Yes I think it was never needed, afaics TRACE_REG_*_UNREGISTER can't
come without successfull _REGISTER. And the bogus uprobe_unregister()
is harmless in this particular case.

So I think this is fine, but perhaps the changelog should mention this
"offtopic" change.

Oleg.

