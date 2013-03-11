Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3CKVyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:54:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKVyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:54:18 -0400
Date: Tue, 12 Mar 2013 00:54:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [PATCH 2/4] drivers: android: binder: Fix code style
Message-ID: <20130311215402.GD9138@mwanda>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
 <1363030315-10229-3-git-send-email-mirsal@mirsal.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363030315-10229-3-git-send-email-mirsal@mirsal.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:31:53PM +0100, Mirsal Ennaime wrote:
> @@ -2943,28 +2944,39 @@ static void binder_deferred_release(struct binder_proc *proc)
>  
>  	threads = 0;
>  	active_transactions = 0;
> +

The blank line here isn't really appropriate.  The initialization is
logically a part of the loop.  It's part of the same paragraph.

>  	while ((n = rb_first(&proc->threads))) {
> -		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
> +		struct binder_thread *thread = rb_entry(n,
> +			struct binder_thread,
> +			rb_node);

Do this instead:
		struct binder_thread *thread;

		thread = rb_entry(n, struct binder_thread, rb_node);

> +
>  		threads++;
>  		active_transactions += binder_free_thread(proc, thread);
>  	}
> +
>  	nodes = 0;
>  	incoming_refs = 0;
> +
>  	while ((n = rb_first(&proc->nodes))) {
> -		struct binder_node *node = rb_entry(n, struct binder_node, rb_node);
> +		struct binder_node *node = rb_entry(n,
> +			struct binder_node,
> +			rb_node);
>  

Same thing again.

regards,
dan carpenter


