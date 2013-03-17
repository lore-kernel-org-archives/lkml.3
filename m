Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3CQTgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:36:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3CQTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:36:13 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dg4Nx7oYL4YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=T1sv73n0zC0A:10 a=jYvyI3cVrODwppLM6HMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363548972.25967.137.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] tracing: syscall_regfunc() should not skip kernel
 threads
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-arch <linux-arch@vger.kernel.org>
Date: Sun, 17 Mar 2013 15:36:12 -0400
In-Reply-To: <20130317190438.GA24582@redhat.com>
References: <20130317182834.GA22989@redhat.com>
	 <1363546493.25967.129.camel@gandalf.local.home>
	 <20130317190438.GA24582@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 20:04 +0100, Oleg Nesterov wrote:

> > I'm really thinking the TIF_SYSCALL_TRACEPOINT flag is getting a bit
> > ridiculous. We really should have a "swap syscall table when tracepoints
> > enabled" that changes the syscall table that does exactly the same thing
> > as the normal table but wraps the system call with the tracepoints.
> 
> But we also need to force the slow path in system_call...

Why? If we remove the tracepoint from the slowpath and use a table swap,
then we wouldn't need to use the slowpath at all.

> 
> Anyway, do you agree with this change for now?

Well, if it's solving a bug today sure. But we should really be looking
at fixing what's there for the future.

-- Steve


