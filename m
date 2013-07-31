Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab3GaQvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:51:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3GaQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:51:45 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=fDhLNHh0KZQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6No3EKuEBNEA:10 a=CIaAqoflp38mQsA4sZ4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375289503.5418.6.camel@gandalf.local.home>
Subject: Re: [PATCH v2 0/1] tracing: trace_remove_event_call() should fail
 if call/file is in use
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
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
Date: Wed, 31 Jul 2013 12:51:43 -0400
In-Reply-To: <20130729175008.GA26284@redhat.com>
References: <20130729175008.GA26284@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 19:50 +0200, Oleg Nesterov wrote:
> Hello.
> 
> On top of "[PATCH v2 0/6] tracing: open/delete fixes" series.
> 
> Perhaps this series should be updated, Masami has some concerns.
> But it seems that you both mostly agree with these changes, so
> let me send the "last" patch for review.
> 
> The last change in kernel/trace/trace_events.c we need to close the
> problems with create/use/delete (at least those which I know ;).
> 
> Now we are ready to change trace_kprobe.c and trace_uprobe.c, Steven
> already has the patches.

Can you refresh my memory. My INBOX is quite full. What were the
subjects for these patches? This fix has lots of different threads, not
to mention versions.

Thanks,

-- Steve

> 
> Changes:
> 
> 	- remove the TRACE_EVENT_FL_REF_MASK (which we do not have)
> 	  check.
> 
> 	  We rely on the previous changes, we do not care if someone
> 	  have an opened file, event_enable_write/etc can do nothing
> 	  but fail after we do remove_event_file_dir().
> 
> 	- Add the comment and a note into the changelog to explain
> 	  why we still need to check FTRACE_EVENT_FL_ENABLED.
> 
> Oleg.
> 
>  include/linux/ftrace_event.h |    2 +-
>  kernel/trace/trace_events.c  |   35 +++++++++++++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 3 deletions(-)


