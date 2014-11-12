Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaKLTtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:49:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45883 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaKLTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:49:52 -0500
Date: Wed, 12 Nov 2014 14:49:49 -0500 (EST)
Message-Id: <20141112.144949.645590790916569141.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECE46C@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2ECE442@RTITMBSV03.realtek.com.tw>
	<20141112.004331.1112374574697663525.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE46C@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 11:49:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 12 Nov 2014 06:29:46 +0000

> David Miller [mailto:davem@davemloft.net] 
>> Sent: Wednesday, November 12, 2014 1:44 PM
> [...]
>> What do other USB network drivers do in similar situations?
> 
> According to the usbnet.c, it would make sure to submit the
> number of min(10, RX_QLEN(dev)) rx buffers. If there are
> not enough rx buffers, it schedule a tasklet for next try.
> 
> The brief flow is as following.
> 1. Call open().
>    - schedule a tasklet.
> 2. Tasklet is called.
>    if (dev->rxq.qlen < RX_QLEN(dev)) {
> 	   - submit rx buffers util the number of
> 	     min(10, RX_QLEN(dev)). If the error
> 	     occurs, break the loop.
> 	   - If the dev->rxq.qlen < RX_QLEN(dev),
> 	     schedule the tasklet.
>    }

That sounds like a better recovery model, why don't you mimick it?
