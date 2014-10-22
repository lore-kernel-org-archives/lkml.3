Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaJVTej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:34:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaJVTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:34:38 -0400
Date: Wed, 22 Oct 2014 15:34:36 -0400 (EDT)
Message-Id: <20141022.153436.93475594748933547.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: isubramanian@apm.com, kchudgar@apm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: net: xgene: Rewrite loop in
 xgene_enet_ecc_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413963581-24019-1-git-send-email-geert@linux-m68k.org>
References: <1413963581-24019-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 12:34:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9MJYj8G010628

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 Oct 2014 09:39:41 +0200

> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: In function ¡xgene_enet_ecc_init¢:
> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:126: warning: ¡data¢ may be used uninitialized in this function
> 
> Depending on the arbitrary value on the stack, the loop may terminate
> too early, and cause a bogus -ENODEV failure.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> v2: Rewrite the loop instead of pre-initializing data.

I hate to be a pest, but like the other patch of your's I think
a do { } while() works best here because the intent is clearly
to run the loop at least once, right?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
