Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaLSRbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:31:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLSRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:31:10 -0500
Date: Fri, 19 Dec 2014 12:31:07 -0500 (EST)
Message-Id: <20141219.123107.1080751255468272638.davem@davemloft.net>
To: fkan@apm.com
Cc: netdev@vger.kernel.org, patches@apm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418945991-31494-1-git-send-email-fkan@apm.com>
References: <1418945991-31494-1-git-send-email-fkan@apm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Dec 2014 09:31:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Kan <fkan@apm.com>
Date: Thu, 18 Dec 2014 15:39:51 -0800

> +#define NO_MAC_FOUND	0
> +#define RES_ENET_CSR	0
> +#define RES_RING_CSR	1
> +#define RES_RING_CMD	2

Don't define your own magic set of error return semantics.

For example, in the MAC address acquisition case, just verify that
you get an ETH_ALEN length value from the fetch routines and return
-ENODEV or similar if you do not.
