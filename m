Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab3K1Qa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:30:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3K1Qax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:30:53 -0500
Date: Thu, 28 Nov 2013 17:31:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH/RFC 17/17] tracing/uprobes: Add @+file_offset fetch
	method
Message-ID: <20131128163148.GA15985@redhat.com>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org> <1385533203-10014-18-git-send-email-namhyung@kernel.org> <20131127185546.GA30544@redhat.com> <877gbtq7rb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gbtq7rb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Namhyung Kim wrote:
>
> I thought we need a fetch_param anyway if we will add support for
> cross-fetch later.  But I won't insist it strongly, I can delay it to
> later work and make current code simpler if you want. :)

OK, great,

> >>  static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
> >>  {
> >>  	struct trace_uprobe *tu;
> >> +	struct uprobe_task *utask;
> >>  	int ret = 0;
> >>
> >>  	tu = container_of(con, struct trace_uprobe, consumer);
> >>  	tu->nhit++;
> >>
> >> +	utask = current->utask;
> >> +	if (utask == NULL)
> >> +		return UPROBE_HANDLER_REMOVE;
> >
> > Hmm, why? The previous change ensures ->utask is not NULL? If we hit
> > NULL we have a bug, we should not remove this uprobe.
>
> Yes, I just want to be defensive. :)
>
> So do you suggest to add BUG_ON()?

We are going to crash with the same effect if it is NULL ;)

> And can I convert or remove a
> similar check in uprobes.c:pre_ssout() too?

Well, yes, we _can_ do this. But unless you have the strong opinion
I'd suggest to not do this. At least right now.

To remind, perhaps we can revert the previous patch later if we find
a better solution (placeholder).

And. Note that we will change this code in any case. I suggested to
use ->vaddr to avoid the other (potentially conflicting) changes in
uprobes.h. Even if we use current->utask, we should add another member
into the union. But again, it would be better to do this later, and
the change will be trivial.

Oleg.

