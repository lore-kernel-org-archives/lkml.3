Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LKSLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3LKSLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:11:17 -0500
Date: Wed, 11 Dec 2013 19:11:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain()
	for tracing handlers
Message-ID: <20131211181155.GA25144@redhat.com>
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com> <52A7C347.1060402@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7C347.1060402@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11, Masami Hiramatsu wrote:
>
> (2013/12/11 0:57), Oleg Nesterov wrote:
> > On 12/10, Masami Hiramatsu wrote:
> >>
> >> and isn't it better to increment
> >> miss-hit counter of the uprobe?
> >
> > What do you mean? This is not miss-hit and ->utask == NULL is quite normal.
>
> But it could skip the handler_chain silently. It could confuse users
> why their probe doesn't hit as expected.

No, we will restart the same (probed) instruction, handle_swbp()
will be called again, get_utask() will be called again.

Not to mention that (in practice) if GFP_KERNEL fails the task is
already killed.

> > For example, on ppc it can be always NULL because ppc likely emulates the
> > probed insn.
>
> Hmm, in that case, should uprobes handlers never be called on ppc with
> this change?

Why? With this change ppc will have ->utask != NULL even if it doesn't
need it at all.

Oleg.

