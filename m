Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3KKJA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:00:27 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55305 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3KKJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:00:20 -0500
Date: Mon, 11 Nov 2013 09:00:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
Message-ID: <20131111090014.GB30901@lee--X1>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a small disclaimer I would personally prefer to not merge this patch.
> I have added it based on previous code review of the other patches in
> this chain.

I'd prefer the functionally redundant 'else if' over the comment.

I'm happy not to merge this patch.

> arizona_hpdet_do_id currently can only return 0 or -EAGAIN making the
> else if clause handling error codes redundant, this patch removes this
> clause.
> 
> Whilst this clause is not currently hit removing it makes the code
> fragile. It will not be obvious whilst editing arizona_hpdet_do_id that
> you shouldn't add a return value other than 0 or -EAGAIN.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 0d70bf6..2313b1e 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -476,6 +476,9 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  	return val;
>  }
>  
> +/* This function should only return 0 or -EAGAIN, if other return values are
> + * added additional handling should be added in arizona_hpdet_irq.
> + */

Please see: Documentation/CodingStyle: Chapter 8: Commenting

>  static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  			       bool *mic)
>  {
> @@ -591,8 +594,6 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
>  	ret = arizona_hpdet_do_id(info, &reading, &mic);
>  	if (ret == -EAGAIN)
>  		goto out;
> -	else if (ret < 0)
> -		goto done;
>  
>  	/* Report high impedence cables as line outputs */
>  	if (reading >= 5000)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
