Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaKDQ3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:29:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56836 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaKDQ3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:29:01 -0500
Date: Tue, 04 Nov 2014 11:28:58 -0500 (EST)
Message-Id: <20141104.112858.356827532569349127.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: fabio.estevam@freescale.com, Frank.Li@freescale.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141104112912.2be8bf1a@ipc1.ka-ro>
References: <20141030.121710.1524000348187962764.davem@davemloft.net>
	<20141031063210.69004315@ipc1.ka-ro>
	<20141104112912.2be8bf1a@ipc1.ka-ro>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 08:29:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Tue, 4 Nov 2014 11:29:12 +0100

> Hi David,
> 
> Lothar Waﬂmann wrote:
>> David Miller wrote:
>> > From: Lothar Waﬂmann <LW@KARO-electronics.de>
>> > Date: Thu, 30 Oct 2014 07:51:04 +0100
>> > 
>> > >> Also, I don't thnk your DIV_ROUND_UP() eliminate for the loop
>> > >> in swap_buffer() is valid.  The whole point is that the current
>> > >> code handles buffers which have a length which is not a multiple
>> > >> of 4 properly, after your change it will no longer do so.
>> > >>
>> > > Do you really think so?
>> > 
>> > Yes, because you're rounding down so you'll miss the final
>> > partial word (if any).
>> >
>> Nope. DIV_ROUND_UP() would give '1' as upper bound for lengths from 1 to
>> 4, '2' for lengths from 5 to 8 and so on.
>> 
>> The loop with increment 4 and i < len does exactly the same.
>> Try it for yourself, if you don't believe it.
>> 
>> 
> Do you still think, the loop without DIV_ROUND_UP() is incorrect,
> or can this patch be applied?

I haven't had the time to fully re-look into the details, I'm busy
with many other things at the moment.

But looking at DIV_ROUND_UP() macro it rounds up.  It gives an
upper bound of 4 for any value 1 to 4.  Unlike what you claim.

Because it goes "(n + (d - 1)) / d"

Which for 'd' of 4 gives:

1 --> 4
2 --> 4
3 --> 4
4 --> 4
