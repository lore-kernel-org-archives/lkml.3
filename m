Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaJ2Tef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:34:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbaJ2Tee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:34:34 -0400
Date: Wed, 29 Oct 2014 15:34:30 -0400 (EDT)
Message-Id: <20141029.153430.1036004676442879956.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Frank.Li@freescale.com, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
	<1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Oct 2014 12:34:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Tue, 28 Oct 2014 14:22:55 +0100

> Changes wrt. v1:
> - added some cleanup patches
> - simplify handling of 'quirks' flags as suggested by Russell King.
> - remove DIV_ROUND_UP() from byte swapping loop as suggested by
>   Eric Dumazet
> 
> Changes wrt. v2:
> - rebased against next-20141028
> - added some more cleanups in fec.h
> - removed unused return value from swap_buffer()
> - fixed messed swab32s() call in swap_buffer2()
> - fixed messed up setup of fep->quirks
> 

It is not appropriate to mix cleanups and bonafide bug fixes.

I want to see only bug fixes targetted at 'net'.  You can later
submit the cleanups to 'net-next'.

Also, I don't thnk your DIV_ROUND_UP() eliminate for the loop
in swap_buffer() is valid.  The whole point is that the current
code handles buffers which have a length which is not a multiple
of 4 properly, after your change it will no longer do so.
