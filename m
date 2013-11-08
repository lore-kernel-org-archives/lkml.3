Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3KHMnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:43:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30254 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683Ab3KHMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:43:41 -0500
Date: Fri, 8 Nov 2013 07:43:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v2 1/8] x86: speed up int3-based patching using less
 paranoid write
Message-ID: <20131108074336.29dfbc15@gandalf.local.home>
In-Reply-To: <527CD34A.30406@hitachi.com>
References: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
	<1383901932-1945-3-git-send-email-pmladek@suse.cz>
	<527CD34A.30406@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Nov 2013 21:04:26 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/11/08 18:12), Petr Mladek wrote:
> > This change is inspired by the int3-based patching code used in
> > ftrace. See the commit fd4363fff3d9 (x86: Introduce int3
> > (breakpoint)-based instruction patching).
> > 
> > When trying to use text_poke_bp in ftrace, the result was slower than
> > the original implementation.
> > 
> > It turned out that one difference was in text_poke vs. ftrace_write.
> > text_poke did many extra operations to make sure that the change
> > was atomic.
> 
> AFAIK, the main reason why text_poke is used is avoiding
> RODATA protection (by alias mapping).

That is correct, and the reason ftrace didn't do that is because it
would be quite expensive to map 22,000 addresses for each change.

-- Steve
