Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3FXS5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3FXS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:57:31 -0400
Date: Mon, 24 Jun 2013 20:53:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130624185301.GA5350@redhat.com>
References: <51C7ED2B.4040701@huawei.com> <20130624180547.GA2794@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624180547.GA2794@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention,

On 06/24, Oleg Nesterov wrote:
>
> > +	/*
> > +	 * Currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive
> > +	 * for uprobe(filter argument issue), this need to fix in future.
                      ^^^^^^^^^^^^^^^^^^^^^

Just in case, this is not that simple.

For example, suppose that TRACE_REG_REGISTER comes after
TRACE_REG_PERF_REGISTER. In this case we need uprobe_perf_open-like
code to establish nr_systemwide != 0 and do uprobe_apply() if
necessary.

Oleg.

