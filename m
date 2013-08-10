Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030813Ab3HJB0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 21:26:18 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51990 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968331Ab3HJB0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 21:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130809162002.GA7144@redhat.com>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
	<1376037909-17797-11-git-send-email-namhyung@kernel.org>
	<5204BCE6.2070102@hitachi.com>
	<20130809162002.GA7144@redhat.com>
Date: Sat, 10 Aug 2013 09:26:15 +0800
Message-ID: <CAGdX0WEMOA286qCmtM9oBcUPZ8qZw8GKDqvk=ROtGsNa=2YgbA@mail.gmail.com>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
From: "zhangwei(Jovi)" <jovi.zhangwei@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 12:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Sorry, I didn't read this series yet. Not that I think this needs my
> help, but I'll try to do this a later...
>
> On 08/09, Masami Hiramatsu wrote:
> >
> > I just concern using kmalloc() in the event handler.
>
> GFP_KERNEL should be fine for uprobe handler.
>
> However, iirc this conflicts with the patches from Jovi,
> "Support ftrace_event_file base multibuffer" adds rcu_read_lock()
> around uprobe_trace_print().

(Sorry about html text rejected by kernel.org, send again with plain text.)

Then we might need to call kmalloc before rcu_read_lock, also call kfree
after rcu_read_unlock.

And it's not needed to call kmalloc for each instances in multi-buffer
case, just
kmalloc once is enough.

I also have same concern about use kmalloc in uprobe handler, use kmalloc
in uprobe handler seems have a little overhead, why not pre-allocate one page
static memory for temp buffer(perhaps trace_uprobe based)? one page size
would be enough for all uprobe args storage, then we don't need to call
kmalloc in that "fast path".

Thanks.
>
>
> Steven, Jovi, what should we do with that patch? It seems that it
> was forgotten.
>
> I can take these patches into my ubprobes branch and then ask Ingo
> to pull. But this will complicate the routing of the new changes
> like this.
>
> Oleg.
