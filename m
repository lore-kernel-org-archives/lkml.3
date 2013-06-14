Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3FNONy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3FNONx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:13:53 -0400
Date: Fri, 14 Jun 2013 16:09:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130614140915.GA30655@redhat.com>
References: <51BA7578.4080108@huawei.com> <51BB18EB.9080307@hitachi.com> <20130614135148.GA30007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614135148.GA30007@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Oleg Nesterov wrote:
>
> On 06/14, Masami Hiramatsu wrote:
> >
> > Srikar, Oleg, could you check that?
>
> I'll definitely try to read this series on Monday.

Yes, but Masami is certainly right. synchronize_sched() can't help
without rcu lock in uprobe_trace_func/etc.

Also, probe_event_enable() can use krealloc() but this is minor.

Oleg.

