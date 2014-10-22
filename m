Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaJVUNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:13:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32937 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaJVUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:12:59 -0400
Date: Wed, 22 Oct 2014 16:12:57 -0400 (EDT)
Message-Id: <20141022.161257.290251379136182774.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: isubramanian@apm.com, kchudgar@apm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: net: xgene: Rewrite loop in
 xgene_enet_ecc_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdXJs=+SpB07t0a+LRWX_TGUnUmQi3P-aExFzmbm_j0fow@mail.gmail.com>
References: <1413963581-24019-1-git-send-email-geert@linux-m68k.org>
	<20141022.153436.93475594748933547.davem@davemloft.net>
	<CAMuHMdXJs=+SpB07t0a+LRWX_TGUnUmQi3P-aExFzmbm_j0fow@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 13:12:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9MKD8Up010853

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 Oct 2014 21:50:06 +0200

> On Wed, Oct 22, 2014 at 9:34 PM, David Miller <davem@davemloft.net> wrote:
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> Date: Wed, 22 Oct 2014 09:39:41 +0200
>>
>>> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: In function ¡xgene_enet_ecc_init¢:
>>> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:126: warning: ¡data¢ may be used uninitialized in this function
>>>
>>> Depending on the arbitrary value on the stack, the loop may terminate
>>> too early, and cause a bogus -ENODEV failure.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> ---
>>> v2: Rewrite the loop instead of pre-initializing data.
>>
>> I hate to be a pest, but like the other patch of your's I think
>> a do { } while() works best here because the intent is clearly
>> to run the loop at least once, right?
> 
> I wanted to avoid checking for "data != ~0U" twice: once to abort the loop,
> and once to check if a timeout happened.

Hmmm:

	do {
		usleep_range(...);
		data = ...();
		if (data == ~0)
			return 0;
	} while (++i < 10);

	netdev_err(...);
	return -ENODEV;

Why would you have to check data twice?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
