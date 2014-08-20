Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaHTOYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:24:07 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37716 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHTOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <1408473119.5604.4.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com>
	<1408459784-9385-2-git-send-email-jonas.jensen@gmail.com>
	<1408473119.5604.4.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 20 Aug 2014 16:24:04 +0200
Message-ID: <CACmBeS0MB+K_30vLACZJ8LqzmXejGQ=PP_t+gFpmke1e5yub9A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 20:31, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Instead of :
>
> priv->rx_buf_size = RX_BUF_SIZE +
>                 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>
> I think rx_buf_size can now be RX_BUF_SIZE

You're right, that's now a remnant, see update in v5.


> Another point is that priv->stats seems not needed, as ndev->stats could
> be used instead (and remove moxart_mac_get_stats())

I will fix that. I can add it to patches adding support for ethtool /
stats and PHY.

I think I'm supposed to post those closer to the merge window, which
would keep this set about bug fixes only.


Regards,


   Jonas
