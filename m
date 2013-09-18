Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3IROUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:20:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60406 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:20:08 -0400
X-Auth-Info: pZyVYWwmd5Xs+A3YWHssaisYhGXw/SyD8WiFu/bs5eQ=
From: Marek Vasut <marex@denx.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: KSZ8051 breakage
Date: Wed, 18 Sep 2013 16:20:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Hector Palacios <hector.palacios@digi.com>,
        "David S. Miller" <davem@davemloft.net>
References: <CAAAP30HuZBw-Vo0ZgbYd_-BqTQwjDFpTDpUrSrwRTSNRmXtBiA@mail.gmail.com>
In-Reply-To: <CAAAP30HuZBw-Vo0ZgbYd_-BqTQwjDFpTDpUrSrwRTSNRmXtBiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201309181620.06885.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Pereira da Silva,

> Hi,
> 
> The commit
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/driv
> ers/net/phy/micrel.c?id=b818d1a7f72575eef17e00dc4085512c9cc8897dbreaks
> KSZ8051MNL phy
> 
> Micrel gone wrong here. The PHY ID of KSZ8051 is the same as KSZ8031, even
> the revision code matches.
> 
> In my custom board, I cannot run these instructions or else my cpu will
> lock up:
> const u16 val = KSZPHY_OMSO_B_CAST_OFF | KSZPHY_OMSO_RMII_OVERRIDE;
> phy_write(phydev, MII_KSZPHY_OMSO, val);
> 
> This is a board property and not a phy one. Ideally, the phy should be
> correctly strapped at the hardware level for the board in question, so no
> changes in this registers should be needed.
> 
> I think we could add a OF property to set these options, what do you think?
> If that, I would also propose to convert the 50MHZ flag to OF as well.
> 
> Other option is to handle this the same way as the 50MHZ flag, that is
> being set by board code.

I wouldn't mind, but we should use something generic the other PHYs can use as 
well.

Best regards,
Marek Vasut
