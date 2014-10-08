Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaJHWWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:22:12 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40540 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaJHWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:22:07 -0400
Date: Wed, 8 Oct 2014 15:22:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Leitner <me@g0hl1n.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: Re: [PATCH] serio: avoid negative serio device numbers
Message-ID: <20141008222200.GH15198@dtor-ws>
References: <20141008235427.55d0963f@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008235427.55d0963f@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:54:27PM +0200, Richard Leitner wrote:
> From: Richard Leitner <richard.leitner@skidata.com>
> 
> Fix the format string for serio device name generation to avoid negative
> device numbers when the id exceeds the maximum signed integer value.
> 
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>

Applied, thank you.

> ---
>  drivers/input/serio/serio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index b29134d..d399b8b 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -524,8 +524,8 @@ static void serio_init_port(struct serio *serio)
>  	spin_lock_init(&serio->lock);
>  	mutex_init(&serio->drv_mutex);
>  	device_initialize(&serio->dev);
> -	dev_set_name(&serio->dev, "serio%ld",
> -			(long)atomic_inc_return(&serio_no) - 1);
> +	dev_set_name(&serio->dev, "serio%lu",
> +		     (unsigned long)atomic_inc_return(&serio_no) - 1);
>  	serio->dev.bus = &serio_bus;
>  	serio->dev.release = serio_release_port;
>  	serio->dev.groups = serio_device_attr_groups;
> -- 
> 2.1.1
> 

-- 
Dmitry
