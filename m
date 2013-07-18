Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3GRBWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 21:22:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab3GRBWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 21:22:38 -0400
Date: Wed, 17 Jul 2013 18:22:37 -0700 (PDT)
Message-Id: <20130717.182237.906875287830581782.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sammy@sammy.net, netdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sun3_82586: Kill array subscript above array
 bounds warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374063905-4050-1-git-send-email-geert@linux-m68k.org>
References: <1374063905-4050-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 17 Jul 2013 18:22:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 Jul 2013 14:25:05 +0200

> drivers/net/ethernet/i825xx/sun3_82586.c: In function 'sun3_82586_timeout':
> drivers/net/ethernet/i825xx/sun3_82586.c:993:89: warning: array subscript is above array bounds [-Warray-bounds]
> 
> Using the default NUM_XMIT_BUFFS = 1, there's only one transmit buffer.
> Hence accessing the second buffer is an out-of-bounds access.
> Print the command status of the first NOP buffer instead.
> 
> Fortunately this actually worked fine, as the layout of transmit and NOP
> buffers is sufficiently similar.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Three more CPP directives in a DEBUG ifdef'd piece of code, yuck.

I'd say just kill this whole DEBUG section entirely.  If people
want this driver to print this debugging, do it properly with
netif_err() or similar.
