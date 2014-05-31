Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbaEaA0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:26:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaEaA0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:26:16 -0400
Date: Fri, 30 May 2014 17:26:15 -0700 (PDT)
Message-Id: <20140530.172615.2243203796607511160.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arcnet: remove check for CONFIG_SA1100_CT6001
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140530.172109.1758735676902083194.davem@davemloft.net>
References: <1401220424.28714.17.camel@x220>
	<20140530.172109.1758735676902083194.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 17:26:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4V0QMBW020383

From: David Miller <davem@davemloft.net>
Date: Fri, 30 May 2014 17:21:09 -0700 (PDT)

> From: Paul Bolle <pebolle@tiscali.nl>
> Date: Tue, 27 May 2014 21:53:44 +0200
> 
>> A check for CONFIG_SA1100_CT6001 was added in v2.6.11. But the related
>> Kconfig symbol was never added to the tree. Remove this check and do
>> some related cleaning up.
>> 
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Applied to net-next, thanks.

Reverted, you missed more references to BUS_ALIGN in com20020.c:

drivers/net/arcnet/com20020.c: In function ¡com20020_check¢:
drivers/net/arcnet/com20020.c:120:22: error: ¡BUS_ALIGN¢ undeclared (first use in this function)
drivers/net/arcnet/com20020.c:120:22: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/arcnet/com20020.c: In function ¡com20020_found¢:
drivers/net/arcnet/com20020.c:182:35: error: ¡BUS_ALIGN¢ undeclared (first use in this function)

For a driver that builds on x86, there is no excuse not to have at least
build tested this patch.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
