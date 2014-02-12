Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaBLMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:51:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751562AbaBLMvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:51:24 -0500
Date: Wed, 12 Feb 2014 07:50:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212075059.0e3d41ab@gandalf.local.home>
In-Reply-To: <20140212083513.GF13997@dastard>
References: <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard>
	<20140212063150.GD13997@dastard>
	<CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
	<20140212083513.GF13997@dastard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 19:35:13 +1100
Dave Chinner <david@fromorbit.com> wrote:


> And it's leaf functions that the CONFIG_STACK_TRACER doesn't catch
> on x86-64 (at least, according to the documentation).
> CONFIG_DEBUG_STACK_USAGE output is showing up to 800 bytes more
> stack usage than the tracer. As such, I also think that
> CONFIG_DEBUG_STACK_USAGE output is a more reliable iindication of
> stack usage because it is canary based and so captures the very
> worst case usage of the process's stack...

Yeah, with the new fentry (adding the mcount call before setting up the
stack frame), the function tracer can not catch leaf functions, as it
is called before the leaf function's frame is set up.

Hmm, I wonder if I should add a config to disable fentry and go back to
the old mcount that gets called after setting up the stack frame. This
will lead to better stack tracing, but you lose out on all the benefits
of fentry.

-- Steve
