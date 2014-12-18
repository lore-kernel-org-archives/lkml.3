Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaLRVvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:51:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49244 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLRVvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:51:40 -0500
Date: Thu, 18 Dec 2014 16:51:38 -0500 (EST)
Message-Id: <20141218.165138.2005282332695465620.davem@davemloft.net>
To: dan@dcollins.co.nz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed TPACKET V3 to signal poll when block is closed
 rather than for every packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418939356.3016.9.camel@voodoo.cms.waikato.ac.nz>
References: <1418939356.3016.9.camel@voodoo.cms.waikato.ac.nz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 13:51:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Collins <dan@dcollins.co.nz>
Date: Fri, 19 Dec 2014 10:49:16 +1300

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

Your email client has corrupted the patch, turning TAB characters into
sequences of SPACE characters.

Please turn off all formatting in your email client, read:

	Documentation/email-clients.txt

for help.
