Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaJHCVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:21:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:25320 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753881AbaJHCVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:21:01 -0400
Date: Tue, 7 Oct 2014 22:20:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/for-next ] tracing/kprobes: Replace startup test
 with selftest script
Message-ID: <20141007222050.59e076e7@gandalf.local.home>
In-Reply-To: <54349A95.6040309@hitachi.com>
References: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal>
	<20141006183349.60998821@gandalf.local.home>
	<5433817C.3000206@hitachi.com>
	<20141007120530.136312fd@gandalf.local.home>
	<54349A95.6040309@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2014 10:59:49 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
 
> > Both of these have valid reasons staying in the kernel and I don't see
> > either as dead weight. Is there a maintenance issue with keeping it in
> > the kernel? There doesn't seem to be much done to it. It seems
> > untouched for over a year, and that was to add support for multiple
> > buffers.
> 
> Keeping it has no issue. But it's much easier to expand the test
> in userspace than the kernel code. I'll add more feature tests in
> kselftest, but not in this code. This means that this startup
> test code will get behind.

And that's exactly what I expect you to do. I have lots of tests to
test ftrace, but what gets tested at kernel startup is just a bare
minimum, and that's all it needs to be. I don't expect you to extend
the start up self tests. That should be only done for the scripts. But
we have this start up test and I don't see a reason to get rid of it.
If anything, it gives me warm fuzzies in my stomach when I see it
pass :-)

The start up tests in the kernel should really just be the basic of the
basic tests, that give a small sanity check that a change didn't
totally screw things up.

Can you send a new patch that doesn't remove the start up test?

Thanks!

-- Steve
