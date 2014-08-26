Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbaHZA0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:26:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658AbaHZA0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:26:16 -0400
Date: Mon, 25 Aug 2014 17:26:15 -0700 (PDT)
Message-Id: <20140825.172615.1598002278628891621.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com, mirqus@gmail.com
Subject: Re: [PATCH v6 4/4] net: moxa: continue loop on skb allocation
 failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408976560-15694-1-git-send-email-jonas.jensen@gmail.com>
References: <1408976560-15694-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:26:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Mon, 25 Aug 2014 16:22:40 +0200

> If netdev_alloc_skb_ip_align() fails, subsequent code will
> try to dereference an invalid pointer.
> 
> Continue to next descriptor on error.
> 
> While we're at it,
> 
> 1. eliminate the chance of an endless loop, replace the main
>    loop with while(rx < budget)
> 
> 2. use napi_complete() and remove the explicit napi_gro_flush()
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied.
