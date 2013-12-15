Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3LOD1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:27:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53208 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3LOD1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:27:00 -0500
Date: Sat, 14 Dec 2013 22:26:58 -0500 (EST)
Message-Id: <20131214.222658.766340465002992773.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: linux-kernel@vger.kernel.org, sebastian@breakpoint.cc,
        sachin.kamat@linaro.org, netdev@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v2 5/9] drivers: net: Put prototype declaration for
 function sbni_probe() in sbni.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
	<dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 14 Dec 2013 19:27:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBF3R6Hn018412

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Sat, 14 Dec 2013 17:55:42 +0530

> This patch declares the prototype for the function sbni_probe() in file sbni.c.
> 
> Thus, it also removes the following warning in wan/sbni.c:
> drivers/net/wan/sbni.c:224:12: warning: no previous prototype for ¡sbni_probe¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This revision fixes the following issues of the previous revision:
> Incorrect fix
> 
>  drivers/net/wan/sbni.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
> index 388ddf6..5061ffd 100644
> --- a/drivers/net/wan/sbni.c
> +++ b/drivers/net/wan/sbni.c
> @@ -221,6 +221,7 @@ static void __init sbni_devsetup(struct net_device *dev)
>  	dev->netdev_ops = &sbni_netdev_ops;
>  }
>  
> +int __init sbni_probe(int unit);
>  int __init sbni_probe(int unit)

This is not the correct way to fix this kind of warning, an exported
function needs to appear in a header file so that both the definition
and any callers of this function will see the same declaration in that
header file.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
