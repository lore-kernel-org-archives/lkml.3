Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaCCW1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:27:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbaCCW1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:27:48 -0500
Message-ID: <531501BD.4070300@zytor.com>
Date: Mon, 03 Mar 2014 14:27:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Petr Mladek <pmladek@suse.cz>, stable@vger.kernel.org
Subject: Re: [RFA][PATCH 1/5] ftrace/x86: Run a sync after fixup on failure
References: <20140227154616.703252665@goodmis.org>	<20140227154922.957070805@goodmis.org>	<5314FE46.3060003@zytor.com> <20140303171816.176ca337@gandalf.local.home>
In-Reply-To: <20140303171816.176ca337@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 02:18 PM, Steven Rostedt wrote:
> 
> How's this sound:
> 
> The second bug was that the removal of the breakpoints required the
> "within()" logic updates instead of accessing the ip address directly.
> As kernel text is mapped read-only when CONFIG_DEBUG_RODATA is set, and
> the removal of the breakpoint is a modification of kernel text.
> 

I'd add:

"ftrace_write() includes this, but probe_kernel_write() does not."

	-hpa


