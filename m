Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3EQTuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:50:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58535 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3EQTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:50:31 -0400
Message-ID: <51968A01.7070105@gmail.com>
Date: Sat, 18 May 2013 01:20:25 +0530
From: govind <govindarajulu90@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: netdev_pick_tx: use get_xps_q if xps map
 is set
References: <1368780528-15209-1-git-send-email-govindarajulu90@gmail.com> <1368797733.3301.84.camel@edumazet-glaptop>
In-Reply-To: <1368797733.3301.84.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 07:05 PM, Eric Dumazet wrote:
> On Fri, 2013-05-17 at 14:18 +0530, govindarajulu.v wrote:
>> From: "govindarajulu.v" <govindarajulu90@gmail.com>
>>
>> netdev_pick_tx ignores the xps map configuration if netdev->ndo_select_queue
>> is defined. Most of the drivers define ndo_select_queue. The problem with this
>> is, if admin wants kernel to pick tx queue based on xps map (instead of driver
>> defined ndo_select_queue), he has to netdev->ndo_select_queue = NULL, compile
>> and reload.
>>
>> This patch fixes it by checking if dev->xps_maps is defined. If yes it
>> proceeds with get_xps_queue. If not it proceeds with netdev->ndo_select_queue
>> (if defined).
>>
>> Compile test only.
>
> I do not think its right, take a look at
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c , around line 6467

I see. In ixgbe_select_queue we use __netdev_pick_tx only if packet is not
FCOE & FIP.

If you see
bnx2x_select_queue in drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c, line 1832
and mlx4_en_select_queue in drivers/net/ethernet/mellanox/mlx4/en_tx.c, line 547.
we cannot have xps working with these drivers.

This needs to be fixed by replacing __skb_tx_hash with __netdev_pick_tx. Am i 
correct?

thanks
//govind
