Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936327Ab3DQR2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:28:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393Ab3DQR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:28:20 -0400
Date: Wed, 17 Apr 2013 13:28:18 -0400 (EDT)
Message-Id: <20130417.132818.1433580618679802344.davem@davemloft.net>
To: n1ght.4nd.d4y@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv6: simplify & condense a few declarations &
 statements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366219222.3504.8.camel@lizardlounge>
References: <1366219222.3504.8.camel@lizardlounge>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 17 Apr 2013 10:28:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Date: Wed, 17 Apr 2013 10:20:22 -0700

> This patch combines several statements/declarations into more concise forms and removes a 
> couple of unnecessary local variables within a few functions, mostly inline.

Please make commit messages with 80 column long lines maximum.

> @@ -111,10 +111,7 @@ static inline void fib6_walker_unlink(struct fib6_walker_t *w)
>  }
>  static __inline__ u32 fib6_new_sernum(void)
>  {
> -	u32 n = ++rt_sernum;
> -	if ((__s32)n <= 0)
> -		rt_sernum = n = 1;
> -	return n;
> +	return (__s32)++rt_sernum <= 0 ? rt_sernum = 1 : rt_sernum;

Like your commit message, I find this unreadable, and definitely not
an improvement.

I'm not applying this even with the long lines in the commit message
fixes, sorry.

