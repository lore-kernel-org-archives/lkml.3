Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3KYHnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 02:43:43 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55022 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3KYHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 02:43:42 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-1b-5292ffac6cd0
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 06/22] tools lib traceevent: Add kmem plugin
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-7-git-send-email-jolsa@redhat.com>
	<1385131097.1747.43.camel@leonhard>
	<20131123040645.63819a5f@gandalf.local.home>
Date: Mon, 25 Nov 2013 16:43:40 +0900
In-Reply-To: <20131123040645.63819a5f@gandalf.local.home> (Steven Rostedt's
	message of "Sat, 23 Nov 2013 04:06:45 -0500")
Message-ID: <87bo19rknn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 04:06:45 -0500, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:38:17 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> It'd be great if the "call_site" in the output changes to display
>> function names instead of hex addresses directly.
>> 
>
> Actually, that's what's in the (). 
>
>    kmem:kmalloc_node: (__alloc_skb+0x7e) call_site=ffffffff8153c67e
>
> This uses a short cut, where we don't overwrite the entire handler, in
> case the TP_printk() gets new fields.
>
> If the registered handler for an event, like "call_site_handler" (see
> how we use it for all of tracepoints) returns >0, that tells the
> library that we only added extra information, and to print the
> tracepoint as it is normally.

Yeah, I know.  But just want to say that it'd be better if it's
displayed like below.

  kmem:kmalloc_node: call_site=__alloc_skb+0x7e ...

But it requires to write new handlers for each event..

>
> The better solution here is to use "%pS" or something in the actual
> tracepoint instead.

Agreed.

Thanks,
Namhyung
