Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaCGDkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:40:46 -0500
Received: from ozlabs.org ([203.10.76.45]:53326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaCGDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:40:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/module: Replace include of tracepoint.h with jump_label.h in module.h
In-Reply-To: <20140306103414.15ab227a@gandalf.local.home>
References: <20140306103414.15ab227a@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Mar 2014 14:02:56 +1030
Message-ID: <87txbay97b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> Rusty,
>
> Can you give an Acked-by for this patch so that I can include it in my
> 3.15 queue. I have some patches there that need to be added before this
> change can go in.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

>
> Thanks,
>
> -- Steve
>
>
> ----
> There's nothing in the module.h header that requires tracepoint.h to be
> included, and there may be cases that tracepoint.h may need to include
> module.h, which will cause recursive header issues.
>
> But module.h requires seeing HAVE_JUMP_LABEL which is set in
> jump_label.h which it just coincidentally gets from tracepoint.h.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/module.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index eaf60ff..5a50539 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -15,7 +15,7 @@
>  #include <linux/stringify.h>
>  #include <linux/kobject.h>
>  #include <linux/moduleparam.h>
> -#include <linux/tracepoint.h>
> +#include <linux/jump_label.h>
>  #include <linux/export.h>
>  
>  #include <linux/percpu.h>
> -- 
> 1.8.5.3
