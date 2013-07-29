Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3G2O1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab3G2O1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:27:30 -0400
Date: Mon, 29 Jul 2013 16:21:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] tracing: Change remove_event_file_dir() to
	clear "d_subdirs"->i_private
Message-ID: <20130729142158.GA9338@redhat.com>
References: <20130726172551.GA3632@redhat.com> <51F6392C.8000806@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F6392C.8000806@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Masami Hiramatsu wrote:
>
> (2013/07/27 2:25), Oleg Nesterov wrote:
> > Change remove_event_file_dir() to clear ->i_private for every
> > file we are going to remove.
>
> Oleg, I think this should be done first.
>
> AFAICS, your former patches depend strongly on this change.
> Without this, they don't work as you expected, and it may
> prevent git-bisect.

Why?

v2 specially does this in the last change for bisecting/etc.

1-4 change f_op->read/write to check i_private != NULL but until
this final patch i_private == NULL is not possible.

> I see, including this patch also breaks current ftrace.

Could you clarify?

Oleg.

