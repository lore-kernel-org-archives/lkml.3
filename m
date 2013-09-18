Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3IRQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:38:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36071 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3IRQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:38:55 -0400
Date: Wed, 18 Sep 2013 12:38:53 -0400 (EDT)
Message-Id: <20130918.123853.1464055976885078627.davem@davemloft.net>
To: thierry.reding@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tsi108: Prevent compiler warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379508595-30252-1-git-send-email-treding@nvidia.com>
References: <1379508595-30252-1-git-send-email-treding@nvidia.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 18 Sep 2013 09:38:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Wed, 18 Sep 2013 14:49:55 +0200

> The dump_eth_one() function is only used if DEBUG is enabled, so protect
> it by a corresponding #ifdef DEBUG block.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

I would prefer that this function and the one call site is simply
removed instead.

This kind of thing can be provided via ethtool register dumps
and therefore without all of the ugliness this ad-hoc stuff
presents.
