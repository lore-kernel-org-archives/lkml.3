Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaF0Axa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:53:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:18788 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461AbaF0Ax3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:53:29 -0400
Date: Thu, 26 Jun 2014 20:53:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Martin Lau <kafai@fb.com>
Cc: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140626205327.5b526302@gandalf.local.home>
In-Reply-To: <20140626183445.GA2663@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
	<20140610114915.5fe24841@gandalf.local.home>
	<20140611055814.GA30265@devbig242.prn2.facebook.com>
	<20140626183445.GA2663@devbig242.prn2.facebook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 11:34:46 -0700
Martin Lau <kafai@fb.com> wrote:

> Hi Steve,
> 
> Can the modified test program reproduce the problem in your test setup?

Ah sorry, got distracted by other work.

OK, I just tried it out, and here's my results:

I ran you code with my current kernel and this is what I got:

# ./ftrace-test-epoll-kafai 
           <...>-3183  [002] ...1    81.777891: tracing_mark_write:
some data 3183: waitting for more data......
3184: written more data

And it just hung there.


Then I applied your patch, compiled and booted it, and ran the test
again, and I got this:

# ./ftrace-test-epoll-kafai

It just hung there. No forward progress.

I don't think that was the result you intended.

-- Steve


