Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbaHZA0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:26:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39809 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658AbaHZA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:26:05 -0400
Date: Mon, 25 Aug 2014 17:26:04 -0700 (PDT)
Message-Id: <20140825.172604.1629510702830732700.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com, mirqus@gmail.com
Subject: Re: [PATCH v6 2/4] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408976542-15624-1-git-send-email-jonas.jensen@gmail.com>
References: <1408544342-32058-1-git-send-email-jonas.jensen@gmail.com>
	<1408976542-15624-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:26:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Mon, 25 Aug 2014 16:22:22 +0200

> build_skb() is used to make skbs out of existing RX ring memory
> which is bad because the RX ring is allocated only once, on probe.
> Memory corruption occur because said memory is reclaimed, i.e.
> __kfree_skb() (and eventually put_page()).
> 
> Replace build_skb() with netdev_alloc_skb_ip_align() and use memcpy().
> 
> Remove SKB_DATA_ALIGN() from RX buffer size while we're at it.
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=69041
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied.
