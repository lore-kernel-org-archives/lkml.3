Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaIAEi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 00:38:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58372 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaIAEi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 00:38:27 -0400
Date: Sun, 31 Aug 2014 21:38:23 -0700 (PDT)
Message-Id: <20140831.213823.1615189696117720659.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: reduce the number of Tx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2516A75@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-24-Taiwan-albertk@realtek.com>
	<20140829.202504.655684636693672249.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2516A75@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 31 Aug 2014 21:38:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 1 Sep 2014 02:46:38 +0000

>  From: David Miller [mailto:davem@davemloft.net] 
> [...]
>> This driver has a loop that iterates MAX_TX times to initialize both
>> the RX and TX buffers.
>> 
>> So if they are not equal, it can't possibly work.
> 
> Excuse me. I don't find that the "RTL8152_MAX_TX" is used by
> rx buffer. The rx buffer only use "RTL8152_MAX_RX". Although 
> the tx buffer size is determined by "rx_buf_sz", the tx buffers
> are independent of rx buffers.

Ok, but that is really confusing code.
