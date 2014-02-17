Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaBQF3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:29:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40257 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaBQF3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:29:39 -0500
Date: Mon, 17 Feb 2014 00:29:37 -0500 (EST)
Message-Id: <20140217.002937.68814317178840128.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: dmitry.tarnyagin@lockless.no, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] caif: delete unnecessary field initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392449773-23429-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1392449773-23429-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2014 21:29:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sat, 15 Feb 2014 08:36:13 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> On success, the function netdev_alloc_skb initializes the dev field of its
> result to its first argument, so this doesn't have to be done in the
> calling context.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression skb,privn,e;
> @@
> 
> skb = netdev_alloc_skb(privn,...);
> ... when strict
> (
> -skb->dev = privn;
> |
> ?skb = e
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to net-next, thanks.
