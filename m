Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778Ab3GPTvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:51:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPTvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:51:38 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=dJJCC7ldWV8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NgCmMRp8MlwA:10 a=oOO8twQCEjA1KnAh5lkA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374004295.6458.59.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 3/4] tracing: Kill tracing_open/release_generic_file
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 15:51:35 -0400
In-Reply-To: <20130716185726.GA21200@redhat.com>
References: <20130716185726.GA21200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 20:57 +0200, Oleg Nesterov wrote:
> Kill tracing_open_generic_file() and tracing_release_generic_file(),
> they are racy anyway.
> 
> Instead, change event_enable_read() and event_enable_write() to rely
> on event_mutex and file_inode(filp)->i_private != NULL check.
> 
> trace_array_get() goes away. NOTE! this is actually wrong until we
> change instance_delete() path to nullify ->i_private.

I think this needs to be done first. Want me to take a crack at it, and
we can interleave our patches if needed.

-- Steve


