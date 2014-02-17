Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaBQV22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:28:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51327 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaBQV2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:28:25 -0500
Date: Mon, 17 Feb 2014 16:28:20 -0500 (EST)
Message-Id: <20140217.162820.1092957787354922201.davem@davemloft.net>
To: tommie@gannert.se
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] irtty-sir.c: Do not set_termios() on irtty_close()
From: David Miller <davem@davemloft.net>
In-Reply-To: <5302750C.6080407@gannert.se>
References: <52FC87B6.4070001@gannert.se>
	<5302750C.6080407@gannert.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 13:28:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tommie Gannert <tommie@gannert.se>
Date: Mon, 17 Feb 2014 20:46:04 +0000

> From: Tommie Gannert <tommie@gannert.se>
> 
> Issuing set_termios() from irtty_close() causes kernel Oops for
> unplugged usb-serial devices.
> 
> Since no other tty_ldisc calls set_termios() on close and no tty driver
> seem to check if tty->device_data is NULL or not on entry to set_termios(),
> the only solution I can come up with is to remove the irtty_stop_receiver()
> call, which only updates termios.
> 
> Signed-off-by: Tommie Gannert <tommie@gannert.se>

Applied, thank you.
