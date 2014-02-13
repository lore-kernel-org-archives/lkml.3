Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBMXvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:51:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBMXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:51:34 -0500
Date: Thu, 13 Feb 2014 18:51:31 -0500 (EST)
Message-Id: <20140213.185131.1052801902077727878.davem@davemloft.net>
To: hs@denx.de
Cc: linux-arm-kernel@lists.infradead.org, mugunthanvnm@ti.com,
        bigeasy@linutronix.de, zonque@gmail.com, balbi@ti.com,
        mpa@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: cpsw: fix buggy loop condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392299247-16917-1-git-send-email-hs@denx.de>
References: <1392299247-16917-1-git-send-email-hs@denx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:51:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Schocher <hs@denx.de>
Date: Thu, 13 Feb 2014 14:47:27 +0100

> commit:
> From 0cd8f9cc0654c06adde353c6532114c5f53a18e8 Mon Sep 17 00:00:00 2001
> From: Mugunthan V N <mugunthanvnm@ti.com>
> Date: Thu, 23 Jan 2014 00:03:12 +0530
> Subject: [PATCH] drivers: net: cpsw: enable promiscuous mode support

The correct way to reference a commit is:

$(SHA1_ID) ("Commit message header text.")

So in this case it would be:

Commit 0cd8f9cc0654c06adde353c6532114c5f53a18e8 ("drivers: net: cpsw:
enable promiscuous mode support")

I fixed this up when applying this patch.  I will not extend this same
courtesy next time.

> Enable promiscuous mode support for CPSW.
> 
> Introduced a crash on an am335x based board (similiar to am335x-evm).
> Reason is buggy end condition in for loop in cpsw_set_promiscious()
> 
> for (i = 0; i <= priv->data.slaves; i++)
> 
> should be
> 
> for (i = 0; i < priv->data.slaves; i++)
> 
> Fix this ...
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>

Applied, thanks.
