Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab3JAEOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 00:14:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41919 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3JAEOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 00:14:48 -0400
Date: Mon, 30 Sep 2013 21:21:53 -0700 (PDT)
Message-Id: <20130930.212153.531876068589922786.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: joe@perches.com, jg1.han@samsung.com, gregkh@linuxfoundation.org,
        wfp5p@virginia.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ll_temac: Reset dma descriptors on ndo_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380281068-13269-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1380281068-13269-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 30 Sep 2013 21:14:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 27 Sep 2013 13:24:28 +0200

> The dma descriptors are only initialized on the probe function.
> 
> If a packet is on the buffer when temac_stop is called, the dma
> descriptors can be left on a incorrect status where no other package can
> be sent.
> 
> So an interface could be left in an usable state after ifdow/ifup.
> 
> This patch makes sure that the descriptors are in a proper status when
> the device is started.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

This analysis is not correct.

In the current driver, the descriptors are allocated and initialized
in the open function, not the probe function.

I'm not applying this patch.
