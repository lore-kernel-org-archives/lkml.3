Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaELX07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:26:59 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47909 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaELX06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:26:58 -0400
Date: Mon, 12 May 2014 16:26:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/2] mtd/onenand: fix build warning for dma type
Message-ID: <20140512232653.GV28907@ld-irv-0074>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:56:14PM +0200, Arnd Bergmann wrote:
> The samsung onenand driver passes around a dma address token
> through a void pointer, which is incorrect and leads to
> warnings like this one:
> 
> onenand/samsung.c:548:2: warning: passing argument 1 of '__fswab32' makes integer from pointer without a cast [enabled by default]
>   writel(src, base + S5PC110_DMA_SRC_ADDR);
>   ^
> 
> This patch makes it use dma_addr_t here, which is more appropriate.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: linux-mtd@lists.infradead.org

Pushed this one to l2-mtd.git. Thanks!

I think the second MTD patch is still under discussion, right? I'll
follow up there if necessary.

Brian
