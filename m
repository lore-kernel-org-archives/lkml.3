Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3EBGp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:45:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49869 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3EBGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:45:56 -0400
Date: Thu, 02 May 2013 02:45:52 -0400 (EDT)
Message-Id: <20130502.024552.1513488878160820332.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: hayeswang@realtek.com, kaber@trash.net, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxoP1vybnqdDwGmd-m0j=x=KDm7GHV6J1i8wGOaU0=5qw@mail.gmail.com>
References: <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
	<CA+55aFzinZSQAS6GW6vYOyQ06+GSMqkCGb8Fu829s_MxY0L0QA@mail.gmail.com>
	<CA+55aFxoP1vybnqdDwGmd-m0j=x=KDm7GHV6J1i8wGOaU0=5qw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 01 May 2013 23:45:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 May 2013 21:55:38 -0700

> I think the positions of those bits matter, and adding
> NETIF_F_HW_VLAN_STAG_*_BIT randomly in the middle broke things. That's
> backed up by the fact that we have things like
> 
>       __UNUSED_NETIF_F_1
> 
> and
> 
>           /**/NETIF_F_GSO_SHIFT,          /* keep the order of SKB_GSO_* bits */
>         NETIF_F_TSO_BIT                 /* ... TCPv4 segmentation */
>                 = NETIF_F_GSO_SHIFT,
> 
> in that array. There is some ordering, and there is some meaning to
> the bit numbers, and adding the *_STAG_* bits in the middle broke some
> subtle dependency.

The other thing this does is it pushes some bits past bit 31.

netdev_features_t, which holds these masks, is 64-bit but we've
already seen one place in a driver where a 32-bit value was being
used.

I'll look more deeply into this, thanks.
