Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbaJ3QRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:17:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56350 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbaJ3QRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:17:16 -0400
Date: Thu, 30 Oct 2014 12:17:10 -0400 (EDT)
Message-Id: <20141030.121710.1524000348187962764.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Frank.Li@freescale.com, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141030075104.05e44b43@ipc1.ka-ro>
References: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
	<20141029.153430.1036004676442879956.davem@davemloft.net>
	<20141030075104.05e44b43@ipc1.ka-ro>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 09:17:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Thu, 30 Oct 2014 07:51:04 +0100

>> Also, I don't thnk your DIV_ROUND_UP() eliminate for the loop
>> in swap_buffer() is valid.  The whole point is that the current
>> code handles buffers which have a length which is not a multiple
>> of 4 properly, after your change it will no longer do so.
>>
> Do you really think so?

Yes, because you're rounding down so you'll miss the final
partial word (if any).
