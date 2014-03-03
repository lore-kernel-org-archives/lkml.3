Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaCCUsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:48:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:46402 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754849AbaCCUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:48:28 -0500
Date: Mon, 3 Mar 2014 15:48:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Filipe Brandenburger <filbranden@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing: introduce a trace_data_offset struct to
 store array size
Message-ID: <20140303154826.570c658f@gandalf.local.home>
In-Reply-To: <1393651938-16418-4-git-send-email-filbranden@google.com>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
	<1393651938-16418-4-git-send-email-filbranden@google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right, this one will bring up discussion.

On Fri, 28 Feb 2014 21:32:18 -0800
Filipe Brandenburger <filbranden@google.com> wrote:

> Commit 7d536cb3f stores the length of the array in the high 16 bits of
> the offset field. Using a struct with two separate 16 bit fields makes
> it cleaner.
> 
> Tested: Boot kernel with this change, set a 'filename ~ "/usr/bin/pst*"'
> regex filter on events/sched/sched_process_exec/filter, enabled tracing,
> checked that calling pstree would log the trace event as expected.
> 

I just applied this and tested it on my PPC64 box, and it gives me the
following:

without patch:

         pst2pdf-3506  [000]   120.700910: sched_process_exec: filename=/usr/bin/pst2pdf pid=3506 old_pid=3506


With patch:

         pstopnm-4432  [001]  1490.246765: sched_process_exec: filename= pid=4432 old_pid=4432


-- Steve
