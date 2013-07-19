Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab3GSRjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:39:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3GSRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:39:54 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=GW4zEVj-RJIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=EWstSE_Q4awA:10 a=VwQbUJbxAAAA:8 a=9mo_egq2CPLsXIghnosA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374255593.3356.16.camel@gandalf.local.home>
Subject: Re: [PATCH 1/1] tracing: Simplify trace_array_get()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 13:39:53 -0400
In-Reply-To: <1374255311.3356.15.camel@gandalf.local.home>
References: <20130719155041.GA19501@redhat.com>
	 <20130719155101.GA19509@redhat.com>
	 <1374251217.3356.12.camel@gandalf.local.home>
	 <20130719163312.GA21544@redhat.com> <20130719172053.GA4845@redhat.com>
	 <1374255311.3356.15.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 13:35 -0400, Steven Rostedt wrote:

> What would happen in that case, is that an event might be enabled or
> disabled in another buffer instance. As that can only happen by the root
> user, it would be the root user doing multiple things at the same time
> to cause it. They might get a strange result at worse, but that would
> also mean they were trying to add and delete instances while reading
> those same instances. Bad root, bad!

In fact, I even mentioned this race in the commit log.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/trace/trace.c?id=ff451961a8b2a17667a7bfa39c86fb9b351445db

-- Steve


