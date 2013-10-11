Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab3JKUFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:05:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16227 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757343Ab3JKUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:05:00 -0400
Message-ID: <1381521888.15023.8.camel@pippen.local.home>
Subject: Re: [PATCH v10 12/12] tracing: define trace_dump_stack() if
 !CONFIG_STACKTRACE
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 16:04:48 -0400
In-Reply-To: <1381498368.19281.15.camel@empanada>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
	 <b88c6631dc9bdd143e5fc19341954e42e59de128.1381445299.git.tom.zanussi@linux.intel.com>
	 <5257F666.7080703@hitachi.com> <1381498368.19281.15.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 08:32 -0500, Tom Zanussi wrote:

> Yeah, it's not easy to turn off CONFIG_STACKTRACE - I basically had to
> tweak a couple Kconfigs to do it, so I could test my stacktrace trigger
> CONFIG_STACKTRACE ifdefs.

If there's no way to do make it fail currently, then it's not really a
problem.

> 
> Still, it's code that explicitly depends on CONFIG_STACKTRACE, so I
> think it makes sense to ifdef it.
> 

If we do decided to do this, then the change belongs in
include/kernel.h:

+#ifdef CONFIG_STACKTRACE
 extern void trace_dump_stack(int skip);
+#else
+static inline void trace_dump_stack(int skip) { }
+#endif

But again, since CONFIG_TRACING can't be configured without
CONFIG_STACKTRACE, I don't believe this change needs to be added.

You can keep it a separate patch locally to your tree for debugging, but
I doesn't need to be upstream.

-- Steve


