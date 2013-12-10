Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3LJBBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:01:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3LJBBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:01:33 -0500
Date: Mon, 09 Dec 2013 20:01:31 -0500 (EST)
Message-Id: <20131209.200131.1376169274733452706.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Enable the hardware pseudo header in
 case of the NET_IP_ALIGN equals 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386323898-2246-1-git-send-email-freddy@asix.com.tw>
References: <1386323898-2246-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 09 Dec 2013 17:01:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: freddy@asix.com.tw
Date: Fri,  6 Dec 2013 17:58:18 +0800

> From: Freddy Xin <freddy@asix.com.tw>
> 
> The AX88179_178A has a hardware feature that it can insert a 2-bytes pseudo
> header in front of each received frame by setting the AX_RX_CTL_IPE bit.
> This feature is used to let the IP header be aligned on a doubleword-aligned address,
> but the NET_IP_ALIGN may equals to 2 and the __netdev_alloc_skb_ip_align in USBNET will
> reserve 2 bytes also, so in this case the driver shouldn't enable this bit.
> 
> This patch modifies the driver to set AX_RX_CTL_IPE just in case of the NET_IP_ALIGN equals 0.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>

Please avoid larger than 80 column lines in your commit messages,
people use text-only tools to viee these.

Next, it makes no sense to restrict your change to NET_IP_ALIGN==0

Simply handle any case, by undoing the reservation if it's getting
in the way.  If there isn't an appropriate helper for this, add one.
