Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbaGNTFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:05:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaGNTE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:04:59 -0400
Date: Mon, 14 Jul 2014 21:03:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] tracing: instance_rmdir() leaks
	ftrace_event_file->filter
Message-ID: <20140714190323.GA19996@redhat.com>
References: <20140711190622.GA19499@redhat.com> <20140711190638.GA19517@redhat.com> <20140714143543.0dc505ea@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714143543.0dc505ea@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Steven Rostedt wrote:
>
> On Fri, 11 Jul 2014 21:06:38 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > @@ -470,6 +470,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
> >
> >  	list_del(&file->list);
> >  	remove_subsystem(file->system);
> > +	free_event_filter(file->filter);
> >  	kmem_cache_free(file_cachep, file);
> >  }
> >
>
> Thanks, looks like this goes back to 3.11. I'll start testing this and
> get it out for stable as well.

Thanks.

Just in case: sorry, I was distracted once again and didn't test 2-7 yet.
Although everything looks simple, even 7/7. But it needs v2 anyway, as
Namhyung pointed out this patch can also change replace_system_preds()
the same way.

Hopefully I'll do this tomorrow, but your review is needed anyway ;)

Oleg.

