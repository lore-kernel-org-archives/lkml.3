Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3FQXLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:11:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40206 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3FQXLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:11:52 -0400
Date: Mon, 17 Jun 2013 16:11:51 -0700 (PDT)
Message-Id: <20130617.161151.1327615665309510068.davem@davemloft.net>
To: linux@roeck-us.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank.Li@freescale.com, jim_baxter@mentor.com
Subject: Re: [PATCH] net: fec: Fix build for MCF5272
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371500179-4733-1-git-send-email-linux@roeck-us.net>
References: <1371500179-4733-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Mon, 17 Jun 2013 13:16:19 -0700

> Commits 4c09eed9 (net: fec: Enable imx6 enet checksum acceleration) and
> baa70a5c (net: fec: enable pause frame to improve rx prefomance for 1G
> network) introduced functionality into the FEC driver which is not
> supported on MCF5272. As result, building images for MCF5272 fails,
> complaining about several undefined symbols.
> 
> Disabled the added functionality for MCF5272 builds.
> 
> Cc: Frank Li <Frank.Li@freescale.com>
> Cc: Jim Baxter <jim_baxter@mentor.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Sorry for the added ifdefs. If anyone has a better idea on how to fix
> the problems, let me know.
> 
> This problem exists in 3.9 as well.

Does the M5272 not have these registers, or have you simply not added
defines for where there offsets are in that silicon instance?

I'd much rather you add the register offset defines than pepper the
entire driver with ifdefs.
