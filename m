Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3EQNfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:35:39 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:48662 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3EQNff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:35:35 -0400
Message-ID: <1368797733.3301.84.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next] net: netdev_pick_tx: use get_xps_q if xps map
 is set
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "govindarajulu.v" <govindarajulu90@gmail.com>
Cc: davem@davemloft.net, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 06:35:33 -0700
In-Reply-To: <1368780528-15209-1-git-send-email-govindarajulu90@gmail.com>
References: <1368780528-15209-1-git-send-email-govindarajulu90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 14:18 +0530, govindarajulu.v wrote:
> From: "govindarajulu.v" <govindarajulu90@gmail.com>
> 
> netdev_pick_tx ignores the xps map configuration if netdev->ndo_select_queue
> is defined. Most of the drivers define ndo_select_queue. The problem with this
> is, if admin wants kernel to pick tx queue based on xps map (instead of driver
> defined ndo_select_queue), he has to netdev->ndo_select_queue = NULL, compile
> and reload.
> 
> This patch fixes it by checking if dev->xps_maps is defined. If yes it
> proceeds with get_xps_queue. If not it proceeds with netdev->ndo_select_queue
> (if defined).
> 
> Compile test only.

I do not think its right, take a look at
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c , around line 6467



