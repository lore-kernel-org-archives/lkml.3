Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaHGFKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:10:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37705 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbaHGFK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:10:29 -0400
X-Originating-IP: 50.43.15.134
Date: Wed, 6 Aug 2014 22:10:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Nick Krause <xerofoiify@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: bug: add unreachable() to silence warnings
Message-ID: <20140807051020.GB2340@thin>
References: <1407375741-3209-1-git-send-email-xerofoiify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407375741-3209-1-git-send-email-xerofoiify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:42:20AM +0200, Nick Krause wrote:
> SuperH BUG() have warnings like
> 
> kernel/sched/core.c:2692:1: warning: control reaches end of non-void function
> [-Wreturn-type]
> net/core/ethtool.c:236:1: warning: control reaches end of non-void function
> [-Wreturn-type]
> 
> Other BUG() implementations
> have added unreachable() at end becuase of which I guess
> it does not showthese errors. We can silence them using unreachable().
> 
> Signed-off-by: Nick Krause <xerofoify@gmail.com>

This change seems reasonable to me.  Unlike the generic version of
BUG(), this one doesn't call panic() or anything else flagged as
__noreturn, so it seems reasonable to add a call to unreachable() here
to tell the compiler that the assembly will trap and not return.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/sh/include/asm/bug.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
> index dcf2780..1ae948f 100644
> --- a/arch/sh/include/asm/bug.h
> +++ b/arch/sh/include/asm/bug.h
> @@ -48,6 +48,7 @@ do {							\
>  		   "i" (__FILE__),			\
>  		   "i" (__LINE__), "i" (0),		\
>  		   "i" (sizeof(struct bug_entry)));	\
> +	unreachable();					\
>  } while (0)
>  
>  #define __WARN_TAINT(taint)				\
> -- 
> 2.0.1
> 
