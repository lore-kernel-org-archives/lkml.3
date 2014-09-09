Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaIIXki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:40:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33854 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaIIXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:40:37 -0400
Date: Tue, 09 Sep 2014 16:40:35 -0700 (PDT)
Message-Id: <20140909.164035.1538611197997884601.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] sparc: leon: Fix race condition between
 leon_cycles_offset and timer_interrupt
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409324958-22902-1-git-send-email-andreas@gaisler.com>
References: <1409324958-22902-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 16:40:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Fri, 29 Aug 2014 17:09:18 +0200

> This makes sure that leon_cycles_offset takes the pending bit into
> account and that leon_clear_clock_irq clears the pending bit. Otherwise,
> if leon_cycles_offset is executed after the timer has wrapped but before
> timer_interrupt has increased timer_cs_internal_counter, time can be
> perceived to go backwards.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied.
