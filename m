Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968059Ab3HIQZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934409Ab3HIQZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:25:47 -0400
Date: Fri, 9 Aug 2013 18:20:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
	ring buffer
Message-ID: <20130809162002.GA7144@redhat.com>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-11-git-send-email-namhyung@kernel.org> <5204BCE6.2070102@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5204BCE6.2070102@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I didn't read this series yet. Not that I think this needs my
help, but I'll try to do this a later...

On 08/09, Masami Hiramatsu wrote:
>
> I just concern using kmalloc() in the event handler.

GFP_KERNEL should be fine for uprobe handler.

However, iirc this conflicts with the patches from Jovi,
"Support ftrace_event_file base multibuffer" adds rcu_read_lock()
around uprobe_trace_print().

Steven, Jovi, what should we do with that patch? It seems that it
was forgotten.

I can take these patches into my ubprobes branch and then ask Ingo
to pull. But this will complicate the routing of the new changes
like this.

Oleg.

