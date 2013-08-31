Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3HaA4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:56:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38186 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3HaA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:56:24 -0400
Date: Fri, 30 Aug 2013 17:56:20 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        pali.rohar@gmail.com
Subject: Re: [PATCH] power: rx51_battery: Replace hardcoded channels values.
Message-ID: <20130831005620.GA28473@teo>
References: <1377125110-16886-1-git-send-email-marek.belisko@open-nandra.com>
 <20130828012752.GD10506@lizard>
 <CAAfyv34Y69L3HLG9GB43JE7_EWWg143BD3jcq8xfmFUraD1JGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAfyv34Y69L3HLG9GB43JE7_EWWg143BD3jcq8xfmFUraD1JGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This issue was introduced in commit:
> power: rx51_battery: Replace hardcoded channels values.
> 
> Original code use channel as argument which was shifted by one in function.
> After mentioned commit argument is already shifted so we need to get index
> back.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Applied, thanks!

> ---
>  drivers/power/rx51_battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
> index 03f5761..1bc5857 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -51,7 +51,7 @@ static int rx51_battery_read_adc(int channel)
>   if (twl4030_madc_conversion(&req) <= 0)
>   return -ENODATA;
> 
> - return req.rbuf[channel];
> + return req.rbuf[ffs(channel) - 1];
>  }
> 
>  /*
