Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3AZJIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 04:08:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34591 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3AZJId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 04:08:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jan 2013 10:07:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/14] firewire: don't use idr_remove_all()
Message-ID: <20130126100707.5c7a7682@stein>
In-Reply-To: <1359163872-1949-5-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
	<1359163872-1949-5-git-send-email-tj@kernel.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25 Tejun Heo wrote:
> idr_destroy() can destroy idr by itself and idr_remove_all() is being
> deprecated.  Drop its usage.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net
> ---
> This patch depends on an earlier idr patch and given the trivial
> nature of the patch, I think it would be best to route these together
> through -mm.  Please holler if there's any objection.

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> Thanks.
> 
>  drivers/firewire/core-cdev.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
> index f8d2287..68c3138 100644
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -1779,7 +1779,6 @@ static int fw_device_op_release(struct inode *inode, struct file *file)
>  	wait_event(client->tx_flush_wait, !has_outbound_transactions(client));
>  
>  	idr_for_each(&client->resource_idr, shutdown_resource, client);
> -	idr_remove_all(&client->resource_idr);
>  	idr_destroy(&client->resource_idr);
>  
>  	list_for_each_entry_safe(event, next_event, &client->event_list, link)



-- 
Stefan Richter
-=====-===-= ---= ==-=-
http://arcgraph.de/sr/
