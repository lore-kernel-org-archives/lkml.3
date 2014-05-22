Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaEVTVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:21:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaEVTVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:21:49 -0400
Date: Thu, 22 May 2014 15:21:46 -0400 (EDT)
Message-Id: <20140522.152146.2116142050088142989.davem@davemloft.net>
To: jim_baxter@mentor.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, bhutchings@solarflare.com,
        edumazet@google.com, mszeredi@suse.cz, fw@strlen.de
Subject: Re: skbuff truesize incorrect.
From: David Miller <davem@davemloft.net>
In-Reply-To: <537E4AFD.20304@mentor.com>
References: <537E4AFD.20304@mentor.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:21:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Baxter <jim_baxter@mentor.com>
Date: Thu, 22 May 2014 20:07:41 +0100

> My questions are:
> 
> 1) Which buffer size does truesize represent, is it the total buffer or
> just the data related to the relevant skb?
> 
> 2) If truesize is for the skb it is contained within should it be
> updated during the call to skb_trim?
> 
> 3) Why does the truesize default to 32960?

skb->truesize represents the total amount of memory that the SKB
is holding up.

This is the size of the sk_buff metadata plus all of the buffer
memory.

For example, if the buffer is using 16K buffer yet only 1500 of it is
actually used for the packet, 16K is what should be plugged into the
equation to compute truesize.

Otherwise it would be easy to compromise a system by sending lots of 1
byte packets to a socket, even though the actual memory consumed by
that "1 byte" packet is significantly larger.
