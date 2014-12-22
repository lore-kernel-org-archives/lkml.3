Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaLVUlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:41:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43190 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVUlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:41:47 -0500
Date: Mon, 22 Dec 2014 15:41:44 -0500 (EST)
Message-Id: <20141222.154144.2133538994062884017.davem@davemloft.net>
To: dan@dcollins.co.nz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed TPACKET V3 to signal poll when block is closed
 rather than every packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418960965-29522-1-git-send-email-dan@dcollins.co.nz>
References: <1418960965-29522-1-git-send-email-dan@dcollins.co.nz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Dec 2014 12:41:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Collins <dan@dcollins.co.nz>
Date: Fri, 19 Dec 2014 16:49:25 +1300

> Make TPACKET_V3 signal poll when block is closed rather than for every
> packet. Side effect is that poll will be signaled when block retire
> timer expires which didn't previously happen. Issue was visible when
> sending packets at a very low frequency such that all blocks are retired
> before packets are received by TPACKET_V3. This caused avoidable packet
> loss. The fix ensures that the signal is sent when blocks are closed
> which covers the normal path where the block is filled as well as the
> path where the timer expires. The case where a block is filled without
> moving to the next block (ie. all blocks are full) will still cause poll
> to be signaled.
> 
> Signed-off-by: Dan Collins <dan@dcollins.co.nz>

Applied, thanks.
