Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DLTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:05:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52537 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3DLTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:05:49 -0400
Date: Fri, 12 Apr 2013 15:05:46 -0400 (EDT)
Message-Id: <20130412.150546.1401935323621074376.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sebastian.hesselbarth@gmail.com, buytenh@wantstofly.org, andrew@lunn.ch,
        jason@lakedaemon.net, florian@openwrt.org, benh@kernel.crashing.org,
        paulus@samba.org, dale@farnsworth.org, bhutchings@solarflare.com,
        smoch@web.de, w@1wt.eu, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mv643xx_eth: remove deprecated inet_lro support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365771339.4459.0.camel@edumazet-glaptop>
References: <1365707488-28819-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1365758400-12565-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1365771339.4459.0.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 12:05:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3CJ5wta015493

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 12 Apr 2013 05:55:39 -0700

> On Fri, 2013-04-12 at 11:20 +0200, Sebastian Hesselbarth wrote:
>> With recent support for GRO, there is no need to keep both LRO and
>> GRO. This patch therefore removes the deprecated inet_lro support
>> from mv643xx_eth. This is work is based on an experimental patch
>> provided by Eric Dumazet and Willy Tarreau.
>> 
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Based-on-patch-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Based-on-patch-by: Willy Tarreau <w@1wt.eu>
>> ---
>> Changes from v1:
>> - also remove INET_LRO from Kconfig (Reported by Eric Dumazet)
> 
> Thanks for finishing this patch
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, but this driver is full of skeletons:

drivers/net/ethernet/marvell/mv643xx_eth.c: In function ¡rxq_refill¢:
drivers/net/ethernet/marvell/mv643xx_eth.c:618:19: error: invalid operands to binary - (have ¡sk_buff_data_t¢ and ¡unsigned char *¢)

which is:

		size = skb->end - skb->data;

that is absolutely not a legal computation.

It happens to be in the only configuration for which this driver
can be enabled in Kconfig but that is no excuse for it :-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
