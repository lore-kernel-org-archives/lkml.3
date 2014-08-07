Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbaHGFH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:07:26 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44296 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaHGFHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:07:04 -0400
X-Originating-IP: 50.43.15.134
Date: Wed, 6 Aug 2014 22:06:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Nick Krause <xerofoiify@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] bug: Add unreachable() to generic BUG() to silence
 warnings
Message-ID: <20140807050654.GA2340@thin>
References: <1407374021-20682-1-git-send-email-xerofoiify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407374021-20682-1-git-send-email-xerofoiify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:13:41AM +0200, Nick Krause wrote:
> Architectures which use generic BUG() have warnings like 
> 
> kernel/sched/core.c:2692:1: warning: control reaches end of non-void function [-Wreturn-type]
> net/core/ethtool.c:236:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> Other BUG() implementations
> have added unreachable() at end but generic does not. I guess
> that is why
> it showing these errors. We can silence them using unreachable().
> 
> Signed-off-by: Nick Krause <xerofoify@gmail.com>

You shouldn't see those warnings.  panic() has __noreturn set, which
should have exactly the same effect.

>  include/asm-generic/bug.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 630dd23..effcc82 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -48,6 +48,7 @@ struct bug_entry {
>  #define BUG() do { \
>  	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
>  	panic("BUG!"); \
> +	unreachable(); \
>  } while (0)
>  #endif
>  
> -- 
> 2.0.1
> 
