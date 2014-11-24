Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKXVmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:42:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54018 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:42:07 -0500
Date: Mon, 24 Nov 2014 16:42:04 -0500 (EST)
Message-Id: <20141124.164204.382324382412456341.davem@davemloft.net>
To: geert+renesas@glider.be
Cc: steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/smsc911x: Add minimal runtime PM support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416855497-6479-1-git-send-email-geert+renesas@glider.be>
References: <1416855497-6479-1-git-send-email-geert+renesas@glider.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 13:42:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Mon, 24 Nov 2014 19:58:17 +0100

> Add minimal runtime PM support (enable on probe, disable on remove), to
> ensure proper operation with a parent device that uses runtime PM.
> 
> This is needed on systems where the external bus controller module of
> the SoC is contained in a PM domain and/or has a gateable functional
> clock. In such cases, before accessing any device connected to the
> external bus, the PM domain must be powered up, and/or the functional
> clock must be enabled, which is typically handled through runtime PM by
> the bus controller driver.
> 
> An example of this is the kzm9g development board, where an smsc9220
> Ethernet controller is connected to the Bus State Controller (BSC) of a
> Renesas sh73a0 SoC.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thanks!
