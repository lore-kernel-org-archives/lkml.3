Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaJHVZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:25:45 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43836 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaJHVZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:25:44 -0400
Date: Wed, 8 Oct 2014 14:25:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Leitner <me@g0hl1n.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: Re: [PATCH] input: avoid negative input device numbers
Message-ID: <20141008212538.GB15198@dtor-ws>
References: <20141008224245.601a1339@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008224245.601a1339@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 10:42:45PM +0200, Richard Leitner wrote:
> From: Richard Leitner <richard.leitner@skidata.com>
> 
> Fix the format string for input device name generation to avoid negative
> device numbers when the id exceeds the maximum signed integer value.

Well, it is going to take us a while to get there :)

Applied, thank you.


> 
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
> ---
>  drivers/input/input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 236bc56..6be6982 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1791,7 +1791,7 @@ struct input_dev *input_allocate_device(void)
>  		INIT_LIST_HEAD(&dev->h_list);
>  		INIT_LIST_HEAD(&dev->node);
>  
> -		dev_set_name(&dev->dev, "input%ld",
> +		dev_set_name(&dev->dev, "input%lu",
>  			     (unsigned long) atomic_inc_return(&input_no) - 1);
>  
>  		__module_get(THIS_MODULE);
> -- 
> 2.1.1
> 

-- 
Dmitry
