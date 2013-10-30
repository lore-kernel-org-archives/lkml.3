Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3J3DI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:08:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52431 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3J3DI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:08:58 -0400
Date: Tue, 29 Oct 2013 23:08:56 -0400 (EDT)
Message-Id: <20131029.230856.328906289275539939.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 2/3] r8152: modify the tx flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <7F69554959F74FA58AE07F06B9FCF029@realtek.com.tw>
References: <1383033377-1178-3-git-send-email-hayeswang@realtek.com>
	<20131029.174936.13317032766742363.davem@davemloft.net>
	<7F69554959F74FA58AE07F06B9FCF029@realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 20:08:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hayeswang <hayeswang@realtek.com>
Date: Wed, 30 Oct 2013 11:03:55 +0800

>  David Miller [mailto:davem@davemloft.net] 
>> Sent: Wednesday, October 30, 2013 5:50 AM
>> To: Hayeswang
>> Cc: netdev@vger.kernel.org; nic_swsd; 
>> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
>> Subject: Re: [PATCH net 2/3] r8152: modify the tx flow
>> 
>> From: Hayes Wang <hayeswang@realtek.com>
>> Date: Tue, 29 Oct 2013 15:56:16 +0800
>> 
>> > Support stopping and waking tx queue. The maximum tx queue length
>> > is 60.
>> 
>> What is so special about the number 60?  It seems arbitrary, and if
>> it isn't arbitrary you haven't described why this value was choosen.
> 
> The value is arbitrary. I think it is better to stop tx when
> queuing many packets, otherwise all the available memory may
> be used for tx skb. The queue length could be any value or
> unlimited if the memory is enough. Should I remove it?

You should at least pick some value that you have analyzed in some
way.  We've done a lot of work to strongly limit the amount of SKB
data which sits in device queues on transmit, and what you're doing
here works against to those goals.

Ideally you should pick a value which is sufficient to meet two
goals at the same time:

1) With constant transmit traffic coming from the networking stack,
   the device never starves for new transmit data to send.

2) We never queue up more traffic than we need to satisfy requirement
   #1.
