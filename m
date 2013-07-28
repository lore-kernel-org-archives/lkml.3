Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3G1DVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 23:21:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52177 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3G1DVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 23:21:08 -0400
Date: Sat, 27 Jul 2013 20:21:07 -0700 (PDT)
Message-Id: <20130727.202107.555068116238400560.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net/usb/r815x: replace USB buffer from stack to
 DMA-able
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374739144-732-1-git-send-email-hayeswang@realtek.com>
References: <20130724.174947.452272360732442554.davem@davemloft.net>
	<1374739144-732-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 27 Jul 2013 20:21:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 25 Jul 2013 15:59:02 +0800

> Some USB buffers use stack which may not be DMA-able.
> Use the buffers from kmalloc to replace those one.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

I don't think it's reasonable to kmalloc() a small integer every time
you want to use a USB message transfer to read or write chip
registers.

Instead, add a scratch buffer to struct r8152 which is allocated once
at driver attach time and which you can use for the transfers.

I think you only need an array of two u32's so something like:

	u32		transfer_buf[2];

ought to be sufficient.

