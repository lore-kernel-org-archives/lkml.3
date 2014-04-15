Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaDOTJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:09:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaDOTJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:09:52 -0400
Date: Tue, 15 Apr 2014 15:09:50 -0400 (EDT)
Message-Id: <20140415.150950.2105729446204659132.davem@davemloft.net>
To: zhen-hual@hp.com
Cc: sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
References: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Apr 2014 12:09:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>
Date: Tue, 15 Apr 2014 14:45:52 +0800

> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> 
> In benet driver, netif_device_detach and netif_device_attach should be
> called between rtnl_lock and rtnl_unlock.
> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>

This absolutely does not look like a driver specific issue, therefore
I do not want you to make such locking context adjustments only in
your driver.

Do it somewhere generic so that every driver gets the fix, not just
your driver.
