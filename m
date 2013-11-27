Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3K0WHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:07:49 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:43085 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3K0WHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:07:47 -0500
Date: Wed, 27 Nov 2013 23:07:46 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix printk output
Message-ID: <20131127220746.GA11255@order.stressinduktion.org>
Mail-Followup-To: Sergei Ianovich <ynvich@gmail.com>,
	linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
References: <1385589839-11767-1-git-send-email-ynvich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385589839-11767-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 02:03:59AM +0400, Sergei Ianovich wrote:
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> ---
>  kernel/module.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index f5a3b1e..6f87299 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -817,7 +817,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  
>  	if (!(flags & O_NONBLOCK)) {
>  		printk(KERN_WARNING
> -		       "waiting module removal not supported: please upgrade");
> +		       "waiting module removal not supported: "
> +		       "please upgrade\n");

Please don't wrap long lines, even if they exceed the 80 line limit. It makes
grepping for them harder.

