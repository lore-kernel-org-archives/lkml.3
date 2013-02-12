Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244Ab3BLPBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:01:09 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34533 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760425Ab3BLPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:01:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360666720-19006-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1360666720-19006-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 12 Feb 2013 20:31:06 +0530
Message-ID: <CAKohpokLbjtbBE48LC_FUHAsR4Y6+vCKoHbpVkxPvpktNZaBbA@mail.gmail.com>
Subject: Re: [PATCH 2/6] dmaengine.h: remove redundant else keyword
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 16:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> dmaengine_device_control returns -ENOSYS in case the dma driver doesn't have
> such functionality.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/dmaengine.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index bfcdecb..b760b38 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -610,8 +610,7 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
>  {
>         if (chan->device->device_control)
>                 return chan->device->device_control(chan, cmd, arg);
> -       else
> -               return -ENOSYS;
> +       return -ENOSYS;

I don't know really which one to prefer here :)

Anyway, if you want this one, then get a blank line before your return code.
