Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaFZBE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:04:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaFZBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:04:56 -0400
Date: Wed, 25 Jun 2014 18:04:55 -0700 (PDT)
Message-Id: <20140625.180455.1940740529236282662.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: _govind@gmx.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] enic: Make dummy rfs functions inline to fix
 !CONFIG_RFS_ACCEL build
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403685069-20198-1-git-send-email-geert@linux-m68k.org>
References: <1403685069-20198-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 18:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Jun 2014 10:31:09 +0200

> If CONFIG_RFS_ACCEL=n:
> 
> drivers/net/ethernet/cisco/enic/enic_main.c: In function 'enic_open':
> drivers/net/ethernet/cisco/enic/enic_main.c:1603:2: error: implicit declaration of function 'enic_rfs_flw_tbl_init' [-Werror=implicit-function-declaration]
> drivers/net/ethernet/cisco/enic/enic_main.c: In function 'enic_stop':
> drivers/net/ethernet/cisco/enic/enic_main.c:1630:2: error: implicit declaration of function 'enic_rfs_flw_tbl_free' [-Werror=implicit-function-declaration]
> 
> Introduced in commit a145df23ef32c7b933875f334ba28791ee75766e ("enic: Add
> Accelerated RFS support").
> 
> Dummy functions are provided, but their prototypes are missing, causing the
> build failure.  Provide dummy static inline functions instead to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks Geert.
