Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3J3VEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:04:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3J3VEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:04:47 -0400
Date: Wed, 30 Oct 2013 17:04:41 -0400 (EDT)
Message-Id: <20131030.170441.2031802071448773661.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] r8152: modify the tx flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383117220-893-3-git-send-email-hayeswang@realtek.com>
References: <1383033377-1178-1-git-send-email-hayeswang@realtek.com>
	<1383117220-893-1-git-send-email-hayeswang@realtek.com>
	<1383117220-893-3-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 30 Oct 2013 14:04:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 30 Oct 2013 15:13:39 +0800

> Remove the code for sending the packet in the rtl8152_start_xmit().
> Let rtl8152_start_xmit() to queue the packet only, and schedule a
> tasklet to send the queued packets. This simplify the code and make
> sure all the packet would be sent by the original order.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Basically, your driver will now queue up to 1,000 packets onto
this tx_queue list, because that is what tx_queue_len will be
for alloc_etherdev() allocated network devices.

In my previous reply to you about this patch, I asked you to
quantify and study the effects of using a limit of 60.  I said
that 60 might be too large.

You've responded by removing the limit completely, which is exactly
the opposite of what I've asked you to do.  Why did you do this?

This patch series is still not in a state where I can apply it,
sorry.
