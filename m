Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaKSRM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:12:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:61617 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755884AbaKSRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:12:24 -0500
Date: Wed, 19 Nov 2014 12:12:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] tracing: Clean up tracing_fill_pipe_page()
Message-ID: <20141119121204.47f047d8@gandalf.local.home>
In-Reply-To: <20141119165149.GF2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
	<20141117141108.347a30e5@gandalf.local.home>
	<20141118161546.GJ23958@pathway.suse.cz>
	<20141119111718.11df478d@gandalf.local.home>
	<20141119165149.GF2332@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 17:51:49 +0100
Petr Mladek <pmladek@suse.cz> wrote:

 
> OK, I'll put it on my todo list. Let's see who is faster ;-) And I
> keep my fingers crossed about the OK from Linus and Andrew.

I'll assume they are going to be OK'd. I'll place these patches in a
separate branch and after I finish testing (and get acks from my
ftrace/core branch), I'll push them all up to my for-next branch.

Then when the merge window opens, I'll push the normal ftrace/core
code, and then push this one separate, and let Linus decide if he wants
to pull it or not.

Here's the commits that are in this branch and not in ftrace/core:

+ 1293ffff tracing: Create seq_buf layer in trace_seq
+ b5e206f2 tracing: Convert seq_buf_path() to be like seq_path()
+ 79033e01 tracing: Convert seq_buf fields to be like seq_file fields
+ f1698325 tracing: Add a seq_buf_clear() helper and clear len and readpos in init
+ 2b644c7f seq_buf: Create seq_buf_used() to find out how much was written
+ a5c4b79c tracing: Clean up tracing_fill_pipe_page()
+ 359ba4a9 tracing: Use trace_seq_used() and seq_buf_used() instead of len
+ 3ae8769e tracing: Add paranoid size check in trace_printk_seq()
+ e1fb15f1 seq_buf: Add seq_buf_can_fit() helper function
+ 02f09612 tracing: Have seq_buf use full buffer
+ d9c7f4b1 tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
+ 678a330a seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
+ a3608c5d seq_buf: Move the seq_buf code to lib/
+ af8f0ef4 printk: Add per_cpu printk func to allow printk to be diverted
+ a066719f x86/nmi: Perform a safe NMI stack trace on all CPUs


-- Steve
