Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaE0Pwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:52:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaE0Pwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:52:46 -0400
Date: Tue, 27 May 2014 11:52:43 -0400 (EDT)
Message-Id: <20140527.115243.2071632723301616912.davem@davemloft.net>
To: David.Laight@ACULAB.COM
Cc: eric.dumazet@gmail.com, jim_baxter@mentor.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kamal@canonical.com, bhutchings@solarflare.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Subject: Re: skbuff truesize incorrect.
From: David Miller <davem@davemloft.net>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1724E565@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D1724C490@AcuExch.aculab.com>
	<20140523.161823.1006372695373018122.davem@davemloft.net>
	<063D6719AE5E284EB5DD2968C1650D6D1724E565@AcuExch.aculab.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 May 2014 08:52:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 27 May 2014 15:23:14 +0000

> True, you still need to sort out how to handle multiple ethernet
> frames in the same 4k page, and arbitrary page boundaries within a
> frame.

Multiple ethernet frames in the same 4K page is used by several ethernet
drivers already.  NIU for one.

Several chips have various pools of pages, chopped up into different
power-of-2 chunks.

As the packet arrives, they build up the packet using buffers from the
different sized pools.

Anyways, you just have to charge the page to all packets contained
within.  This doesn't seem to be much of an issue to address.
