Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaEVTdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:33:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaEVTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:33:16 -0400
Date: Thu, 22 May 2014 15:33:13 -0400 (EDT)
Message-Id: <20140522.153313.958087444510569794.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: gerrit@erg.abdn.ac.uk, gxt@mprc.pku.edu.cn, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] net/dccp/timer.c: use 'u64' instead of
 's64' to avoid compiler's warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <537BF116.9000900@gmail.com>
References: <537BF116.9000900@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:33:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4MJXSh0029408

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Wed, 21 May 2014 08:19:34 +0800

> 'dccp_timestamp_seed' is initialized once by ktime_get_real() in
> dccp_timestamping_init(). It is always less than ktime_get_real()
> in dccp_timestamp().
> 
> Then, ktime_us_delta() in dccp_timestamp() will always return positive
> number. So can use manual type cast to let compiler and do_div() know
> about it to avoid warning.
> 
> The related warning (with allmodconfig under unicore32):
> 
>     CC [M]  net/dccp/timer.o
>   net/dccp/timer.c: In function ¡dccp_timestamp¢:
>   net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied to net-next, thanks.

But that type check in include/asm-generic/div64.h is bogus, it should
be checking sizeof(X) == 8 rather than the type thing, it just wants to
make sure that the value is 64-bit regardless of it's signedness.

The arch local implementations do not do this, and that's why very few
other people notice this warning.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
