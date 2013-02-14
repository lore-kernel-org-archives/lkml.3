Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076Ab3BNXVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:21:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759643Ab3BNXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:21:24 -0500
Date: Thu, 14 Feb 2013 15:21:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: [RESEND] [PATCH] kernel/res_counter.c: remove useless return
 statement at res_counter_member()
Message-Id: <20130214152122.920f4936.akpm@linux-foundation.org>
In-Reply-To: <510C9E74.3070402@oracle.com>
References: <510C9E74.3070402@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2013 13:04:52 +0800
Jeff Liu <jeff.liu@oracle.com> wrote:

> The return statement after BUG() is invalid, move BUG() to the default choice of the switch.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  kernel/res_counter.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index ff55247..748a3bc 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -135,10 +135,9 @@ res_counter_member(struct res_counter *counter, int member)
>  		return &counter->failcnt;
>  	case RES_SOFT_LIMIT:
>  		return &counter->soft_limit;
> +	default:
> +		BUG();
>  	};
> -
> -	BUG();
> -	return NULL;
>  }
>  
>  ssize_t res_counter_read(struct res_counter *counter, int member,

I expect it was done that way to avoid a hey-theres-no-return-statement
warning when CONFIG_BUG=n.

