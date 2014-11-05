Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaKEO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:26:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbaKEO0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:26:34 -0500
Date: Wed, 5 Nov 2014 15:26:20 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in trace_seq
Message-ID: <20141105142620.GD4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.864997179@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160221.864997179@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:40, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> be limited to page size. This will allow other usages of seq_buf
> instead of a hard set PAGE_SIZE one that trace_seq has.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h              |  72 ++++++++
>  include/linux/trace_seq.h            |  10 +-
>  kernel/trace/Makefile                |   1 +
>  kernel/trace/seq_buf.c               | 341 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                 |  39 ++--
>  kernel/trace/trace_events.c          |   6 +-
>  kernel/trace/trace_functions_graph.c |   6 +-
>  kernel/trace/trace_seq.c             | 184 +++++++++----------
>  8 files changed, 534 insertions(+), 125 deletions(-)
>  create mode 100644 include/linux/seq_buf.h
>  create mode 100644 kernel/trace/seq_buf.c
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> new file mode 100644
> index 000000000000..97872154d51c
> --- /dev/null
> +++ b/include/linux/seq_buf.h
> @@ -0,0 +1,72 @@
> +#ifndef _LINUX_SEQ_BUF_H
> +#define _LINUX_SEQ_BUF_H
> +
> +#include <linux/fs.h>
> +
> +#include <asm/page.h>

One more small thing. We do not need this include because
seq_buf does not use the PAGE_SIZE.

Best Regards,
Petr
