Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaIZOSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:18:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:63292 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754101AbaIZOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:18:43 -0400
Date: Fri, 26 Sep 2014 10:18:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
Message-ID: <20140926101840.7d495620@gandalf.local.home>
In-Reply-To: <5425564A.4020107@hitachi.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<5422EAE2.6080005@osg.samsung.com>
	<20140924120853.0a717b7e@gandalf.local.home>
	<5422EFB4.2050104@osg.samsung.com>
	<20140924123007.7fcb0099@gandalf.local.home>
	<5422F328.2040707@osg.samsung.com>
	<5425564A.4020107@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 21:04:26 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> > Please go ahead and get them in. The framework might have to wait
> > until 3.19, so there is no need to have it gate test development.
> > We can evolve them as we go. If tests require special, it means that
> > they aren't suitable for certain envs such as qemu boot with busybox.
> > There is a plan to add test targets to cover such cases.
> 
> Agreed, anyway, in some env those tools(commands) may not supported
> by busybox because of the memory size etc. In that case, we can just
> mark the test unsupported or xfail.
> 

Note, if memory size is such a big issue it that other tools may not be
there, then most of the ftrace features will probably be disabled due
to memory constraints on the kernel itself.

As we have a way to state "unsupported" we can just return that from
tests that require tools not available, and say why it is the case.

-- Steve
