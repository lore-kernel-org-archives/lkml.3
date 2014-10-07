Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaJGQFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:05:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17244 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753176AbaJGQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:05:33 -0400
Date: Tue, 7 Oct 2014 12:05:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/for-next ] tracing/kprobes: Replace startup test
 with selftest script
Message-ID: <20141007120530.136312fd@gandalf.local.home>
In-Reply-To: <5433817C.3000206@hitachi.com>
References: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal>
	<20141006183349.60998821@gandalf.local.home>
	<5433817C.3000206@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2014 15:00:28 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/10/07 7:33), Steven Rostedt wrote:
> > On Mon, 06 Oct 2014 11:48:06 +0000
> > Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> Replace the kprobe_tracer's startup test with two selftest scripts.
> >> These test cases are testing that the kprobe_event can accept a
> >> kprobe event with $stack related arguments and a kretprobe event
> >> with $retval argument.
> > 
> > Can't we keep both? I have boxes I run my own tests with and enables
> > these start up tests in the kernel. I don't plan on testing on all
> > theses boxes using the scripts in the kernel.
> > 
> > Having a self test in the kernel itself can be useful too.
> 
> Hmm, deprecating the test is acceptable, but I think it is just
> a dead weight that if we have both of them forever in the kernel.
> Of course, if that feature is fundamentally related to booting up
> the kernel, we need to keep them in boot up code. But if it is
> possible to run after booting up, I think we'd better to move it
> under kselftest, since we can do more investigation after booting.
> 

I'm just saying that it is more likely to have this test run if it's in
the kernel than in userspace. But as you say, we can debug it better if
there's a userspace tool that can run too. This is why I'm saying we
should keep both. I think they are both useful for different reasons.
Keeping it in the kernel as a config option will give it more exposure,
and keeping it in the tools/testing directory gives us a way to debug
it if there an issue should arise.

Both of these have valid reasons staying in the kernel and I don't see
either as dead weight. Is there a maintenance issue with keeping it in
the kernel? There doesn't seem to be much done to it. It seems
untouched for over a year, and that was to add support for multiple
buffers.

-- Steve
