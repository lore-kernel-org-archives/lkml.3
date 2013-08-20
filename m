Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3HTWHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:07:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47934 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3HTWHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:07:40 -0400
Date: Tue, 20 Aug 2013 15:07:39 -0700 (PDT)
Message-Id: <20130820.150739.295329075883411467.davem@davemloft.net>
To: al@alarsen.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: ethtool cannot change parameters when link is
 down
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376819680-15359-1-git-send-email-al@alarsen.net>
References: <1376819680-15359-1-git-send-email-al@alarsen.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 15:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Larsen <al@alarsen.net>
Date: Sun, 18 Aug 2013 11:54:40 +0200

> When attempting to change e.g. the advertising mask when the link is down
> ecmd->speed is -1 causing mii_ethtool_sset() to bail out.
> 
> This bug bit when connecting to a gigabit switch through a 4-pin (industrial)
> cable, since link negotiation would not complete (both endpoints claimed to
> be gigabit-capable, but this is not possible with only 4 pins).
> Any attempt to fix this by setting autonegation to not offer 1000Mbps
> failed as the setting would not be accepted while the link was still down...
> 
> Set ecmd->speed to SPEED_1000 to satisfy mii_ethtool_sset()
> (the actual value of ecmd->speed doesn't matter as long as it is valid,
> since a re-negotation is forced afterwards).
> 
> Signed-off-by: Anders Larsen <al@alarsen.net>

Applied.
