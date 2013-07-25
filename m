Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3GYBYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:24:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3GYBYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:24:08 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=JnOv4dvnuGwhp6quMyYA:9 a=QEXdDO2ut3YA:10 a=DdYowudkXfDnKeFB:21 a=ng-RXzEF0Hg5XBQj:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374715444.3356.163.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        steve@purestorage.com
Date: Wed, 24 Jul 2013 21:24:04 -0400
In-Reply-To: <20130724160422.GA3641@logfs.org>
References: <20130705142629.GA325@redhat.com>
	 <1373036034.22688.155.camel@gandalf.local.home>
	 <20130724160422.GA3641@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 12:04 -0400, Jörn Engel wrote:
> On Fri, 5 July 2013 10:53:54 -0400, Steven Rostedt wrote:
> > 
> > Can you find an easy reproducer for this?
> 
> We might have found something:
> 
> Jul 23 19:00:59 [28253.487058,08] WARNING: at kernel/trace/ftrace.c:1529 __ftrace_hash_rec_update+0x1e3/0x230()
> Jul 23 19:00:59 [28253.487203,08] Pid: 20903, comm: bash Tainted: G           O 3.6.11+ #38405.trunk
> Jul 23 19:00:59 [28253.487206,08] Call Trace:
> Jul 23 19:00:59 [28253.487213,08]  [<ffffffff8103e5ff>] warn_slowpath_common+0x7f/0xc0
> Jul 23 19:00:59 [28253.487218,08]  [<ffffffff8103e65a>] warn_slowpath_null+0x1a/0x20
> Jul 23 19:00:59 [28253.487222,08]  [<ffffffff810c2ee3>] __ftrace_hash_rec_update+0x1e3/0x230
> Jul 23 19:00:59 [28253.487227,08]  [<ffffffff810c4f28>] ftrace_hash_move+0x28/0x1d0
> Jul 23 19:00:59 [28253.487232,08]  [<ffffffff811401cc>] ? kfree+0x2c/0x110
> Jul 23 19:00:59 [28253.487237,08]  [<ffffffff810c68ee>] ftrace_regex_release+0x8e/0x150
> Jul 23 19:00:59 [28253.487242,08]  [<ffffffff81149f1e>] __fput+0xae/0x220
> Jul 23 19:00:59 [28253.487247,08]  [<ffffffff8114a09e>] ____fput+0xe/0x10
> Jul 23 19:00:59 [28253.487252,08]  [<ffffffff8105fa22>] task_work_run+0x72/0x90
> Jul 23 19:00:59 [28253.487257,08]  [<ffffffff810028ec>] do_notify_resume+0x6c/0xc0
> Jul 23 19:00:59 [28253.487262,08]  [<ffffffff8126596e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> Jul 23 19:00:59 [28253.487267,08]  [<ffffffff815c0f88>] int_signal+0x12/0x17
> Jul 23 19:00:59 [28253.487271,08] ---[ end trace 793179526ee09b2c ]---
> 
> Jul 23 19:21:02 [  775.393547,08] WARNING: at kernel/trace/ftrace.c:1529 __ftrace_hash_rec_update+0x1e3/0x230()
> Jul 23 19:21:02 [  775.393715,08] Pid: 6376, comm: bash Tainted: G           O 3.6.11+ #38405.trunk
> Jul 23 19:21:02 [  775.393718,08] Call Trace:
> Jul 23 19:21:02 [  775.393727,08]  [<ffffffff8103e5ff>] warn_slowpath_common+0x7f/0xc0
> Jul 23 19:21:02 [  775.393732,08]  [<ffffffff8103e65a>] warn_slowpath_null+0x1a/0x20
> Jul 23 19:21:02 [  775.393737,08]  [<ffffffff810c2ee3>] __ftrace_hash_rec_update+0x1e3/0x230
> Jul 23 19:21:02 [  775.393741,08]  [<ffffffff810c4f28>] ftrace_hash_move+0x28/0x1d0
> Jul 23 19:21:02 [  775.393748,08]  [<ffffffff811401cc>] ? kfree+0x2c/0x110
> Jul 23 19:21:02 [  775.393754,08]  [<ffffffff810c68ee>] ftrace_regex_release+0x8e/0x150
> Jul 23 19:21:02 [  775.393771,08]  [<ffffffff81149f1e>] __fput+0xae/0x220
> Jul 23 19:21:02 [  775.393784,08]  [<ffffffff8114a09e>] ____fput+0xe/0x10
> Jul 23 19:21:02 [  775.393792,08]  [<ffffffff8105fa22>] task_work_run+0x72/0x90
> Jul 23 19:21:02 [  775.393798,08]  [<ffffffff810028ec>] do_notify_resume+0x6c/0xc0
> Jul 23 19:21:02 [  775.393804,08]  [<ffffffff8126596e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> Jul 23 19:21:02 [  775.393810,08]  [<ffffffff815c0f88>] int_signal+0x12/0x17
> Jul 23 19:21:02 [  775.393814,08] ---[ end trace 3b86cc549cc5483e ]---
> 
> If I understand Steve correctly, you have to enable a trace somewhere
> in a module, them rmmod that module without disabling the trace.  Easy
> enough to avoid, but maybe you are interested.

I'm a bit confused by this. What do you mean exactly by enable a trace
somewhere in a module? The module enables the trace? Does it have its
own ftrace_ops? Or the module just starts tracing?

-- Steve


