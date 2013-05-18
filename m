Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab3ERFSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 01:18:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45930 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3ERFS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 01:18:29 -0400
Message-ID: <51970F1F.5070101@gmail.com>
Date: Sat, 18 May 2013 10:48:23 +0530
From: govind <govindarajulu90@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: netdev_pick_tx: use get_xps_q if xps map
 is set
References: <1368780528-15209-1-git-send-email-govindarajulu90@gmail.com>  <1368797733.3301.84.camel@edumazet-glaptop> <51968A01.7070105@gmail.com> <1368828197.3301.112.camel@edumazet-glaptop>
In-Reply-To: <1368828197.3301.112.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On 05/18/2013 03:33 AM, Eric Dumazet wrote:
> On Sat, 2013-05-18 at 01:20 +0530, govind wrote:
>
>> I see. In ixgbe_select_queue we use __netdev_pick_tx only if packet is not
>> FCOE & FIP.
>>
>> If you see
>> bnx2x_select_queue in drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c, line 1832
>> and mlx4_en_select_queue in drivers/net/ethernet/mellanox/mlx4/en_tx.c, line 547.
>> we cannot have xps working with these drivers.
>>
>> This needs to be fixed by replacing __skb_tx_hash with __netdev_pick_tx. Am i
>> correct?
>
> Yes, this seems better.

thanks eric, i will send patch soon.

//govind
