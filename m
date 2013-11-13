Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab3KMRM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:12:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40533 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3KMRMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:12:22 -0500
Date: Wed, 13 Nov 2013 09:12:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: Make struct rcu_head searchable
Message-ID: <20131113171205.GG4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131113120225.3aacae13@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113120225.3aacae13@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111317-1344-0000-0000-0000033A219E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 12:02:25PM -0500, Steven Rostedt wrote:
> After wasting too much time trying to see where struct rcu_head was
> declared, I finally found it in include/linux/types.h as a define for
> callback_head!
> 
> To prevent other developers from wasting their precious time in
> searching for this structure, add a comment to help them find it!
> 
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven "frustrated" Rostedt <rostedt@goodmis.org>

The cscope tool is your friend in this case, but nevertheless:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> diff --git a/include/linux/types.h b/include/linux/types.h
> index 4d118ba..073e9a8 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -210,6 +210,9 @@ struct callback_head {
>  	struct callback_head *next;
>  	void (*func)(struct callback_head *head);
>  };
> +/*
> + * Make "struct rcu_head {" seachable with this comment.
> + */
>  #define rcu_head callback_head
> 
>  #endif /*  __ASSEMBLY__ */
> 

