Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaCZUaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:30:11 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42829 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaCZUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:30:08 -0400
Date: Wed, 26 Mar 2014 13:30:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input: Use RCU_INIT_POINTER(x, NULL) in evdev.c
Message-ID: <20140326203005.GC11013@core.coreip.homeip.net>
References: <1395599177-6776-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395599177-6776-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Monam,

On Sun, Mar 23, 2014 at 11:56:17PM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Logically speaking we perform assignment, not initialization there.
Since we are not in hot path I think we should leave the code as is.

Thanks.

> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
>  drivers/input/evdev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index a06e125..fffa107 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -291,7 +291,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  	if (grab != client)
>  		return  -EINVAL;
>  
> -	rcu_assign_pointer(evdev->grab, NULL);
> +	RCU_INIT_POINTER(evdev->grab, NULL);
>  	synchronize_rcu();
>  	input_release_device(&evdev->handle);
>  
> -- 
> 1.7.9.5
> 

-- 
Dmitry
