Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaKEUwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:52:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48026 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaKEUwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:52:09 -0500
Date: Wed, 05 Nov 2014 15:52:07 -0500 (EST)
Message-Id: <20141105.155207.760255373450633226.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: fabio.estevam@freescale.com, Frank.Li@freescale.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: net: fec: fix regression on i.MX28 introduced by rx_copybreak
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141105062148.2a997b95@ipc1.ka-ro>
References: <20141104112912.2be8bf1a@ipc1.ka-ro>
	<20141104.112858.356827532569349127.davem@davemloft.net>
	<20141105062148.2a997b95@ipc1.ka-ro>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 12:52:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Wed, 5 Nov 2014 06:21:48 +0100

> David Miller wrote:
>> Because it goes "(n + (d - 1)) / d"
>> 
>> Which for 'd' of 4 gives:
>> 
>> 1 --> 4
>> 2 --> 4
>> 3 --> 4
>> 4 --> 4
>>
> '1', not '4'.
> The loop has to be done once for each (probably partial) WORD of input
> data, not for each BYTE.

You're right, thanks for being so patient with me.

Please repost your patch, I'll integrate it.

Thanks.
