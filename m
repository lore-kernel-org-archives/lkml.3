Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3F0QcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3F0QcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:32:23 -0400
Date: Thu, 27 Jun 2013 18:27:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130627162720.GA18961@redhat.com>
References: <51C90ECC.9030303@huawei.com> <20130627121231.GB8362@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627121231.GB8362@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Srikar Dronamraju wrote:
>
> * zhangwei(Jovi) <jovi.zhangwei@huawei.com> [2013-06-25 11:30:20]:
> > +	if (!enabled) {
> > +		tu->consumer.filter = filter;
> > +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> > +		if (ret)
> > +			tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
>
> Dont we need to free link here? or where does the link that got
> allocated freed?

Agreed...

Masami, it seems that (just in case, with or without "Turn trace_probe->files
into list_head" I sent) trace_kpobes needs the similar fix too? Plus it should
clear TP_FLAG_* if enable_k.*probe() fails.

Or enable_trace_probe() assumes that enable_kprobe() must succeed? In this
case probably WARN_ON(ret) makes sense.

Oleg.

