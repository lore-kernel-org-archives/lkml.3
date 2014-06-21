Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbaFUMHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:07:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59846 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaFUMHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:07:32 -0400
Date: Sat, 21 Jun 2014 14:07:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@gmail.com>
Subject: Re: [for-next][PATCH] tracing: Add __field_struct macro for
 TRACE_EVENT()
Message-ID: <20140621120723.GC25200@pd.tnic>
References: <20140621075025.1aadb1f6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140621075025.1aadb1f6@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 07:50:25AM -0400, Steven Rostedt wrote:
> 
> Updates to the RAS tracepoints found that the __field() macro has a bug
> in it where you can not use it with structures. It only works with
> primitives. This is because of an added check to determine if the field
> is signed or not.
> 
> A new macro is created called __field_struct() that can be used to save
> structured data directly in the tracepoint and not have to settle for
> storing as an array with memcpy.
> 
> -- Steve
> 
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next
> 
> Head SHA1: 4d4c9cc839a308be3289a361ccba4447ee140552
> 
> 
> Steven Rostedt (1):
>       tracing: Add __field_struct macro for TRACE_EVENT()
> 
> ----
>  include/trace/ftrace.h                     | 33 ++++++++++++++++++++++++++++++
>  samples/trace_events/trace-events-sample.h |  3 ++-
>  2 files changed, 35 insertions(+), 1 deletion(-)
> ---------------------------
> commit 4d4c9cc839a308be3289a361ccba4447ee140552
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Tue Jun 17 08:59:16 2014 -0400
> 
>     tracing: Add __field_struct macro for TRACE_EVENT()
>     
>     Currently the __field() macro in TRACE_EVENT is only good for primitive
>     values, such as integers and pointers, but it fails on complex data types
>     such as structures or unions. This is because the __field() macro
>     determines if the variable is signed or not with the test of:
>     
>       (((type)(-1)) < (type)1)
>     
>     Unfortunately, that fails when type is a structure.
>     
>     Since trace events should support structures as fields a new macro
>     is created for such a case called __field_struct() which acts exactly
>     the same as __field() does but it does not do the signed type check
>     and just uses a constant false for that answer.
>     
>     Cc: Tony Luck <tony.luck@gmail.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
