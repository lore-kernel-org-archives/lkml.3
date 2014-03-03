Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaCCWSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:18:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:18560 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755326AbaCCWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:18:19 -0500
Date: Mon, 3 Mar 2014 17:18:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Petr Mladek <pmladek@suse.cz>, stable@vger.kernel.org
Subject: Re: [RFA][PATCH 1/5] ftrace/x86: Run a sync after fixup on failure
Message-ID: <20140303171816.176ca337@gandalf.local.home>
In-Reply-To: <5314FE46.3060003@zytor.com>
References: <20140227154616.703252665@goodmis.org>
	<20140227154922.957070805@goodmis.org>
	<5314FE46.3060003@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2014 14:12:22 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/27/2014 07:46 AM, Steven Rostedt wrote:
> > The second bug was that the removal of the breakpoints required the
> > "within()" logic updates instead of accessing the ip address directly.
> 
> Please update this bit to clarify, as we discussed on IRC.

How's this sound:

The second bug was that the removal of the breakpoints required the
"within()" logic updates instead of accessing the ip address directly.
As kernel text is mapped read-only when CONFIG_DEBUG_RODATA is set, and
the removal of the breakpoint is a modification of kernel text.


> 
> Otherwise:
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>

Thanks!

-- Steve
