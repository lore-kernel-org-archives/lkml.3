Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3FNQXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3FNQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:23:54 -0400
Date: Fri, 14 Jun 2013 18:18:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ftrace multibuffer && rcu (Was: tracing/uprobes: Support
	ftrace_event_file base multibuffer)
Message-ID: <20130614161837.GA15268@redhat.com>
References: <51BA7578.4080108@huawei.com> <20130614144442.GA1943@redhat.com> <20130614160456.GA14726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614160456.GA14726@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Oleg Nesterov wrote:
>
> So perhaps something like below (untested) makes sense? With this patch
> we can trivially convert trace_kprobe.c to use list_add/del/each_rcu.

Forgot to mention, the patch is obviously incomplete, __kprobe_trace_func()
can see the "dead" file even if its memory can't go away. But this looks
fixable.

> +static inline struct event_file_link *
> +alloc_event_file_link(struct ftrace_event_file *file)
> +{
> +	struct event_file_link *link = kmalloc(sizeof(*link), GFP_KERNEL);
> +	if (link)
> +		link->file = file;
> +	return link;
> +}

And this lacks atomic_inc(file->refcnt).

In short, this is just to explain what I meant, the actual change should
probably differ.

Oleg.

