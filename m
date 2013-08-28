Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3H1ObF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:31:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3H1ObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:31:03 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jxQzypR4wcoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qWrlR9Lw5PkA:10 a=nstwEb_VeCF9HUpF9ysA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 10:31:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828103101.3f5679bc@gandalf.local.home>
In-Reply-To: <20130828034627.GA30596@redhat.com>
References: <20130828034627.GA30596@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

BTW, is there a way to run trinity on a subset of syscalls. Basically,
I would like to run it on just the perf code, and nothing else. I have
a feeling that the bug you see is not caused by other operations
happening (although it could be), but from just out of order perf
calls. If I can reproduce it, I'll have a much better way of debugging
this.

Perhaps another thing you may think of adding to trinity (if it doesn't
already exist), is a log of what it is doing. That is, to log somewhere
the commands it writes, and that way, if something goes wrong, you have
a clue to how it got there. Because this is one of those bugs that
triggered before the code crashes, and the crash is just the symptom of
what went wrong and does not give you much clue to how it happened.

-- Steve
