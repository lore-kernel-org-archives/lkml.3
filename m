Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LLRZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:25:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3LLRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:25:44 -0500
Date: Thu, 12 Dec 2013 12:25:42 -0500 (EST)
Message-Id: <20131212.122542.1538675820432940524.davem@davemloft.net>
To: qais.yousef@imgtec.com
Cc: yangyingliang@huawei.com, edumazet@google.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] net/sched/sch_tbf.c: fix linking error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
References: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 09:25:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qais Yousef <qais.yousef@imgtec.com>
Date: Thu, 12 Dec 2013 12:38:56 +0000

> ERROR: "__udivdi3" [net/sched/sch_tbf.ko] undefined!
> 
> introduced by: cc106e441a63 (net: sched: tbf: fix the calculation of max_size)
> 
> which adds a 64 by 32 bit division without using do_div().
> Fix it by using do_div(len/ 53) instead of len/53.
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-next@vger.kernel.org
> ---
> We caught this error on linux-next today. This is my quick attemp of a fix.
> If it's not appropriate or doesn't make sense my apologies and feel free to
> resend a better fix :)

This is already fixed in the net-next tree.
