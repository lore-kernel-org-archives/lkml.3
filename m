Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaAOXMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:12:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41796 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaAOXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:12:07 -0500
Date: Wed, 15 Jan 2014 15:12:06 -0800 (PST)
Message-Id: <20140115.151206.1969611706248707914.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: ogerlitz@mellanox.com, jackm@dev.mellanox.co.il, ronye@mellanox.com,
        hadarh@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net/mlx4_core: clean up cq_res_start_move_to()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389728736.28068.8.camel@x220>
References: <1389099678.15032.19.camel@x41>
	<20140114084752.1db64b21@jpm-OptiPlex-GX620>
	<1389728736.28068.8.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 14 Jan 2014 20:45:36 +0100

> Building resource_tracker.o triggers a GCC warning:
>     drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: In function 'mlx4_HW2SW_CQ_wrapper':
>     drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:3019:16: warning: 'cq' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       atomic_dec(&cq->mtt->ref_count);
>                     ^
> 
> This is a false positive. But a cleanup of cq_res_start_move_to() can
> help GCC here. The code currently uses a switch statement where an
> if/else construct would do too, since only two of the switch's four
> cases can ever occur. Dropping that switch makes the warning go away.
> 
> While we're at it, add some missing braces.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: adjust to Jack's review.

Can I please get some review of these two patches, thank you.
