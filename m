Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaJIXFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:05:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJIXFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:05:19 -0400
Date: Thu, 09 Oct 2014 19:05:17 -0400 (EDT)
Message-Id: <20141009.190517.1411360749517857554.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: use mutex for hw settings
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2EC397B@RTITMBSTEMP01.realtek.com.tw>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
	<20141008.154513.1944594723904521723.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EC397B@RTITMBSTEMP01.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Oct 2014 16:05:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 9 Oct 2014 07:59:35 +0000

> If I use the rtnl_lock(), I get a dead lock when enabling autosuspend.
> 
> Case 1:
>    autosuspend before calling open.
>    rtnl_lock()
>    call open
>    try to autoresume and rtl8152_resume is called.
>    dead lock occurs.
> 
> Case 2:
>    autosuspend occurs.
>    rtnl_lock()
>    call close
>    try to autoresume and rtl8152_resume is called.
>    dead lock occurs.

That's really unfortunate that we can variably get into the resume
handlers from contexts holding the RTNL mutex.

