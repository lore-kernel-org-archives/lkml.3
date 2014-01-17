Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaAQAFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:05:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAQAFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:05:19 -0500
Date: Thu, 16 Jan 2014 16:05:17 -0800 (PST)
Message-Id: <20140116.160517.1449593192794233083.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: ogerlitz@mellanox.com, jackm@dev.mellanox.co.il, ronye@mellanox.com,
        hadarh@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net/mlx4_core: clean up srq_res_start_move_to()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389728812.28068.9.camel@x220>
References: <1389099734.15032.20.camel@x41>
	<20140114084050.70a612af@jpm-OptiPlex-GX620>
	<1389728812.28068.9.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 14 Jan 2014 20:46:52 +0100

> Building resource_tracker.o triggers a GCC warning:
>     drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: In function 'mlx4_HW2SW_SRQ_wrapper':
>     drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:3202:17: warning: 'srq' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       atomic_dec(&srq->mtt->ref_count);
>                      ^
> 
> This is a false positive. But a cleanup of srq_res_start_move_to() can
> help GCC here. The code currently uses a switch statement where a plain
> if/else would do, since only two of the switch's four cases can ever
> occur. Dropping that switch makes the warning go away.
> 
> While we're at it, add some missing braces, and convert state to the
> correct type.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
