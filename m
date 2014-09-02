Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaIBUWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:22:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaIBUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:22:18 -0400
Date: Tue, 02 Sep 2014 13:22:17 -0700 (PDT)
Message-Id: <20140902.132217.1247025622945425190.davem@davemloft.net>
To: stigge@antcom.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lpc_eth: Fix crash on ip link up
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409572006-26876-1-git-send-email-stigge@antcom.de>
References: <1409572006-26876-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Sep 2014 13:22:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stigge@antcom.de
Date: Mon,  1 Sep 2014 13:46:46 +0200

> From: Roland Stigge <stigge@antcom.de>
> 
> When a link is already up, the following sequence makes the kernel
> block completely:
> 
>   ip link set dev eth0 down
>   ip link set dev eth0 up
> 
> This is because on suspended phy, the following lines
> 
>   __lpc_eth_reset(pldat);
>   __lpc_eth_init(pldat);
> 
> make the LPC ethernet core block (see LPC32x0 manual). The PHY needs to be
> (re-)activated low-level first.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied, thanks.
