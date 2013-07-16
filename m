Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab3GPTis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:38:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPTir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:38:47 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=sAMN5JoDUTkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=MM5Jvx6deYgA:10 a=xd1Zz08zVNS97sm7fOwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374003524.6458.51.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
 opening probe event files and deleting probe
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Jul 2013 15:38:44 -0400
In-Reply-To: <20130716192200.GA21716@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130715180149.GA15821@redhat.com> <20130716163804.GA30560@redhat.com>
	 <1374001825.6458.44.camel@gandalf.local.home>
	 <20130716192200.GA21716@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 21:22 +0200, Oleg Nesterov wrote:

> But tracing_open_generic_file()->trace_array_get() is racy, no?
> Somehow we need to ensure it is safe to use file / file->tr.

Ah crap. Yeah, I see what you mean. It's the race that I described with
deleting private data and using it on open. :-p


> Btw, Steven, what about other pending (and orthogonal changes) ?
> >From Jovi, from me. I see nothing new in linux-trace.git#for-next...

My INBOX is full with too much crap. I thought I grabbed the patches
from you and Jovi, but they may have been something else.

Can you just tell me what the subjects were. My INBOX currently has
>10,000 emails, and it's just getting worse.

-- Steve


