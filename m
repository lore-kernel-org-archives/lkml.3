Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaFFDq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:46:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21423 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088AbaFFDqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:46:25 -0400
Date: Thu, 5 Jun 2014 23:46:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core 1/3] trace/event: Return error if
 ftrace_trace_arrays is empty list
Message-ID: <20140605234623.484afaf8@gandalf.local.home>
In-Reply-To: <20140605223517.32311.99233.stgit@yunodevel>
References: <20140605223515.32311.71203.stgit@yunodevel>
	<20140605223517.32311.99233.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 07:35:17 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> ftrace_trace_arrays links global_trace.list. However, global_trace is not added
> to ftrace_trace_arrays if trace_alloc_buffers() failed. As the result,
> ftrace_trace_arrays becomes empty list. If ftrace_trace_arrays is empty list,
> current top_trace_array() returns invalid pointer. As the result, the kernel
> can induce memory corruption or panic.
> 
> Current implementation does not check whether ftrace_trace_arrays is empty
> list or not. So, in this patch, if ftrace_trace_arrays is empty list,
> top_trace_array() returns NULL. Moreover, this patch makes all functions calling
> top_trace_array() handle it appropriately.

As I'm still working on some more patches for 3.16, I can add this.
It's not that critical, because if global_array fails to allocate on
boot up, lots of other things may also break.

-- Steve

> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
