Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaLZXmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:42:47 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39582 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLZXmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:42:44 -0500
Date: Fri, 26 Dec 2014 15:42:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Helge Deller <deller@gmx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/13] incorrect use of init_completion fixup
Message-ID: <20141226234239.GB1071@dtor-ws>
References: <1419581170-5182-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419581170-5182-1-git-send-email-der.herr@hofr.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 09:06:10AM +0100, Nicholas Mc Guire wrote:
> The successive init_completion calls should be reinit_completion calls.
> 
> patch against 3.19.0-rc1 linux-next
> 
> Acked-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Applied, thank you.

> ---
>  drivers/input/keyboard/hil_kbd.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
> index 610a8af..5b152f2 100644
> --- a/drivers/input/keyboard/hil_kbd.c
> +++ b/drivers/input/keyboard/hil_kbd.c
> @@ -473,7 +473,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
>  	if (error)
>  		goto bail1;
> 
> -	init_completion(&dev->cmd_done);
> +	reinit_completion(&dev->cmd_done);
>  	serio_write(serio, 0);
>  	serio_write(serio, 0);
>  	serio_write(serio, HIL_PKT_CMD >> 8);
> @@ -482,7 +482,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
>  	if (error)
>  		goto bail1;
> 
> -	init_completion(&dev->cmd_done);
> +	reinit_completion(&dev->cmd_done);
>  	serio_write(serio, 0);
>  	serio_write(serio, 0);
>  	serio_write(serio, HIL_PKT_CMD >> 8);
> @@ -491,7 +491,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
>  	if (error)
>  		goto bail1;
> 
> -	init_completion(&dev->cmd_done);
> +	reinit_completion(&dev->cmd_done);
>  	serio_write(serio, 0);
>  	serio_write(serio, 0);
>  	serio_write(serio, HIL_PKT_CMD >> 8);
> --
> 1.7.10.4
> 

-- 
Dmitry
