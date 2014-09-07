Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIGXMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:12:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaIGXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:12:31 -0400
Date: Sun, 07 Sep 2014 16:12:30 -0700 (PDT)
Message-Id: <20140907.161230.1498704332590876012.davem@davemloft.net>
To: b.galvani@gmail.com
Cc: f.fainelli@gmail.com, maxime.ripard@free-electrons.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mdio-sun4i: don't select REGULATOR
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409956103-23473-1-git-send-email-b.galvani@gmail.com>
References: <1409956103-23473-1-git-send-email-b.galvani@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Sep 2014 16:12:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beniamino Galvani <b.galvani@gmail.com>
Date: Sat,  6 Sep 2014 00:28:23 +0200

> The mdio-sun4i driver automatically selects REGULATOR and
> REGULATOR_FIXED_VOLTAGE because it uses the regulator API. But a
> driver selecting a subsystem increases the chance of generating
> circular Kconfig dependencies, especially when other drivers depend on
> the selected symbol.
> 
> Since the regulator API functions are replaced with no-ops when
> REGULATOR is disabled, the driver can be built successfully even
> without regulator support and so those 'select' dependencies can be
> safely dropped.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Applied to net-next, thanks.
