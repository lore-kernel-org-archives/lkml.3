Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaERXBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:01:04 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63345 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaERXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:01:02 -0400
Date: Sun, 18 May 2014 16:00:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-input@vger.kernel.org, andrew.smirnov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ims-pcu - fix uninitialized use of 'error' in
 ims_pcu_buffers_alloc()
Message-ID: <20140518230058.GA27053@core.coreip.homeip.net>
References: <1400449278-14513-1-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400449278-14513-1-git-send-email-cengelma@gmx.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 11:41:18PM +0200, Christian Engelmayer wrote:
> In case allocation via usb_alloc_coherent() fails in ims_pcu_buffers_alloc(),
> the function jumps to the exit path without initializing local variable
> 'error' that is used as return value. Detected by Coverity - CID 1016531.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Applied, thank you.

> ---
> This is an allocation function and all currently coded error scenarios
> result in -ENOMEM. Thus it would be possible to eliminate 'error' at all and
> always return -ENOMEM in the error path.
> 
> Compile tested. Applies against branch next in tree
> git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> ---
>  drivers/input/misc/ims-pcu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
> index 5a73639..719410f 100644
> --- a/drivers/input/misc/ims-pcu.c
> +++ b/drivers/input/misc/ims-pcu.c
> @@ -1566,6 +1566,7 @@ static int ims_pcu_buffers_alloc(struct ims_pcu *pcu)
>  	if (!pcu->urb_ctrl_buf) {
>  		dev_err(pcu->dev,
>  			"Failed to allocate memory for read buffer\n");
> +		error = -ENOMEM;
>  		goto err_free_urb_out_buf;
>  	}
>  
> -- 
> 1.9.1
> 

-- 
Dmitry
