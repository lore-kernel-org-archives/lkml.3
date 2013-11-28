Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3K1XZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 18:25:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47367 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3K1XZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 18:25:07 -0500
Date: Thu, 28 Nov 2013 18:25:05 -0500 (EST)
Message-Id: <20131128.182505.1593147138692009632.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: johannes.berg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genetlink: Fix uninitialized variable in
 genl_validate_assign_mc_groups()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385208110-17120-1-git-send-email-geert@linux-m68k.org>
References: <1385208110-17120-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Nov 2013 15:25:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rASNPJ7x030370

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 23 Nov 2013 13:01:50 +0100

> net/netlink/genetlink.c: In function ¡genl_validate_assign_mc_groups¢:
> net/netlink/genetlink.c:217: warning: ¡err¢ may be used uninitialized in this
> function
> 
> Commit 2a94fe48f32ccf7321450a2cc07f2b724a444e5b ("genetlink: make multicast
> groups const, prevent abuse") split genl_register_mc_group() in multiple
> functions, but dropped the initialization of err.
> 
> Initialize err to zero to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Question: Is the for_each_net_rcu() loop in genl_validate_assign_mc_groups()
>           guaranteed to loop at least once?
> 	  If yes, this is a false positive.

Applied, but yes it's a false positive.  There is always &init_net so the
loop always iterates at least once.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
