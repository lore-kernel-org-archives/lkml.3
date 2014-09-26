Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaIZOqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:46:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54313 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaIZOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:46:41 -0400
Subject: Re: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Shuah Khan <shuahkh@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <54255411.4090508@hitachi.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	 <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home>
	 <20140924115811.6eeeab8c@gandalf.local.home>
	 <5422EAE2.6080005@osg.samsung.com>
	 <20140924120853.0a717b7e@gandalf.local.home>
	 <877g0qkj9g.fsf@sejong.aot.lge.com>  <54255411.4090508@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Sep 2014 23:46:33 +0900
Message-ID: <1411742793.1669.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

2014-09-26 (금), 20:54 +0900, Masami Hiramatsu:
> (2014/09/26 15:06), Namhyung Kim wrote:
> > Hi Steve,
> > 
> > On Wed, 24 Sep 2014 12:08:53 -0400, Steven Rostedt wrote:
> >> On Wed, 24 Sep 2014 10:01:38 -0600
> >> Shuah Khan <shuahkh@osg.samsung.com> wrote:
> >>
> >>> I am working on adding the framework for c tests. We will have
> >>> to get this evolved for shell scripts. Please see the following
> >>> thread:
> >>>
> >>> https://lkml.org/lkml/2014/9/23/926
> >>>
> >>
> >> Thanks,
> >>
> >> Also, what's the rules for a test that requires other tools. Some of my
> >> tests require trace-cmd to be installed as well as perf. My stress test
> >> runs perf against trace-cmd running hackbench (another required tool),
> >> but I believe that perf has hackbench built in so I could replace
> >> hackbench with the perf version.
> > 
> > Yeah, and I think we can at least build perf (if not found) for test as
> > we can always have the source.  The trace-cmd is different and it'd be
> > another reason I need to work on 'perf ftrace' command soon.  ;-)
> 
> +1 :)
> 
> For the kselftest, we can only expect to have tools in kernel tree (which
> should be static-linked) and busybox, so that we can use qemu emulator to
> run kselftest on other archs. I guess perf still need some shared
> objects to run. That should be solved too.

The perf should be built with no extra dependencies (other than libc).
It won't provide rich features but basic functionality (record, report,
stat) should be supported.  And I'm also thinking about implementing a
very simple elf parser for symbol loading in such a minimal build.

Thanks,
Namhyung


> 
> Anyway, at first we'd better add simpler tests which is not relay on
> other tools except busybox shell.
> 
> Thank you,
> 
> 



