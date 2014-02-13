Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaBMOQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:16:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36126 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaBMOQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:16:29 -0500
Message-ID: <52FCD356.4060201@ti.com>
Date: Thu, 13 Feb 2014 19:44:46 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, <linux-arm-kernel@lists.infradead.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Daniel Mack <zonque@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Markus Pargmann <mpa@pengutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: cpsw: fix buggy loop condition
References: <1392299247-16917-1-git-send-email-hs@denx.de>
In-Reply-To: <1392299247-16917-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 February 2014 07:17 PM, Heiko Schocher wrote:
> commit:
> From 0cd8f9cc0654c06adde353c6532114c5f53a18e8 Mon Sep 17 00:00:00 2001
> From: Mugunthan V N <mugunthanvnm@ti.com>
> Date: Thu, 23 Jan 2014 00:03:12 +0530
> Subject: [PATCH] drivers: net: cpsw: enable promiscuous mode support
>
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
> Cc: Mugunthan V N <mugunthanvnm@ti.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Sebastian Siewior <bigeasy@linutronix.de>
> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Markus Pargmann <mpa@pengutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
Ah, it's copy paste error, thanks for the fix.

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
