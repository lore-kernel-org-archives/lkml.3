Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaKZRHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:07:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48666 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKZRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:07:00 -0500
Date: Wed, 26 Nov 2014 12:06:58 -0500 (EST)
Message-Id: <20141126.120658.498602780456343676.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: drop the tx packet with invalid length
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394712342-15778-104-Taiwan-albertk@realtek.com>
	<1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Nov 2014 09:07:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 26 Nov 2014 08:52:28 -0800

> On Wed, 2014-11-26 at 17:56 +0800, Hayes Wang wrote:
>> Drop the tx packet which is more than the size of agg_buf_sz. When
>> creating a bridge with the device, we may get the tx packet with
>> TSO and the length is more than the gso_max_size which is set by
>> the driver through netif_set_gso_max_size(). Such packets couldn't
>> be transmitted and should be dropped directly.
>> 
>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
 ...
> Looks like a candidate for ndo_gso_check(), so that we do not drop, but
> instead segment from netif_needs_gso()/validate_xmit_skb()

You mean have the bridge implement the ndo_gso_check() method right?
