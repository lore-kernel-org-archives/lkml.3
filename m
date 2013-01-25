Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3AYHxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:53:38 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61960 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3AYHxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:53:35 -0500
Date: Fri, 25 Jan 2013 08:53:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools lib traceevent: Handle dynamic array's element
 size properly
Message-ID: <20130125075330.GA21036@gmail.com>
References: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
 <1358829942.21576.49.camel@gandalf.local.home>
 <20130122131646.GB1037@krava.brq.redhat.com>
 <20130124192801.GB14382@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124192801.GB14382@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Jan 22, 2013 at 02:16:47PM +0100, Jiri Olsa escreveu:
> > On Mon, Jan 21, 2013 at 11:45:42PM -0500, Steven Rostedt wrote:
> > > This is only used in this function (the field_dynamic_elem_size() is
> > > only called here). Can we not add the field->type_dyn, and just use a
> > > local variable here. You just need to make sure you free it correctly.
> > 
> > ook, will send v2
> 
> Waiting for this fix, just got 'perf test' crashing on it again :-)
> 
> Till then I implemented 'perf test --skip':

Hm, I think perf test should fork() a testing thread and be 
robust against a child catching a SIGSEGV?

That would also protect against a test corrupting perf test 
itself.

Thanks,

	Ingo
