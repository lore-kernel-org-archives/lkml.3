Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3EQWDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:03:24 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49008 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab3EQWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:03:19 -0400
Message-ID: <1368828197.3301.112.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next] net: netdev_pick_tx: use get_xps_q if xps map
 is set
From: Eric Dumazet <eric.dumazet@gmail.com>
To: govind <govindarajulu90@gmail.com>
Cc: davem@davemloft.net, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 15:03:17 -0700
In-Reply-To: <51968A01.7070105@gmail.com>
References: <1368780528-15209-1-git-send-email-govindarajulu90@gmail.com>
	 <1368797733.3301.84.camel@edumazet-glaptop> <51968A01.7070105@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-18 at 01:20 +0530, govind wrote:

> I see. In ixgbe_select_queue we use __netdev_pick_tx only if packet is not
> FCOE & FIP.
> 
> If you see
> bnx2x_select_queue in drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c, line 1832
> and mlx4_en_select_queue in drivers/net/ethernet/mellanox/mlx4/en_tx.c, line 547.
> we cannot have xps working with these drivers.
> 
> This needs to be fixed by replacing __skb_tx_hash with __netdev_pick_tx. Am i 
> correct?

Yes, this seems better.


