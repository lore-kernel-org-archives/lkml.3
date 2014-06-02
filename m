Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaFBCRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:17:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55355 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaFBCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:17:39 -0400
Date: Sun, 01 Jun 2014 19:17:37 -0700 (PDT)
Message-Id: <20140601.191737.1821014891784987464.davem@davemloft.net>
To: amirv@mellanox.com
Cc: ogerlitz@mellanox.com, netdev@vger.kernel.org, yevgenyp@mellanox.com,
        yuvala@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V6 0/2] cpumask,net: Affinity hint helper
 function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
References: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Jun 2014 19:17:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Sun, 25 May 2014 17:47:25 +0300

> This patchset will set affinity hint to influence IRQs to be allocated on the
> same NUMA node as the one where the card resides. As discussed in
> http://www.spinics.net/lists/netdev/msg271497.html
> 
> If the number of IRQs allocated is greater than the number of local NUMA cores, all
> local cores will be used first, and the rest of the IRQs will be on a remote
> NUMA node.
> If no NUMA support - IRQ's and cores will be mapped 1:1
> 
> Since the utility function to calculate the mapping could be useful in other mq
> drivers in the kernel, it was added to cpumask.[ch]
> 
> This patchset was tested and applied on top of net-next since the first
> consumer is a network device (mlx4_en).  Over commit 506724c: "tg3: Override
> clock, link aware and link idle mode during NVRAM dump"
> 
> I couldn't find a maintainer for cpumask.c, so only added the kernel mailing
> list

Applied to net-next, thanks.
