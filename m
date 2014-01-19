Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaASRgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 12:36:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaASRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 12:36:36 -0500
Date: Sun, 19 Jan 2014 09:37:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
Message-ID: <20140119173712.GA26481@kroah.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 02:55:07PM +0900, SeongJae Park wrote:
> Following build comes while modprobe process:
> > ERROR: "__clk_get_hw" [drivers/clk/clk-max77686.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > make[1]: *** [modules] Error 2
> 
> Export the symbol to fix it and for other part's usecase.
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  drivers/clk/clk.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 2b38dc9..3883fba 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -575,6 +575,7 @@ struct clk_hw *__clk_get_hw(struct clk *clk)
>  {
>  	return !clk ? NULL : clk->hw;
>  }
> +EXPORT_SYMBOL_GPL(__clk_get_hw);

__ functions should usually only be for "internal" use, why does this
get exported to modules?  Why not just put it in a .h file?

greg k-h
