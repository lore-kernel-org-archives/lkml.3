Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaGUD6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:58:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaGUD6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:58:32 -0400
Date: Sun, 20 Jul 2014 20:58:30 -0700 (PDT)
Message-Id: <20140720.205830.595868255699983537.davem@davemloft.net>
To: ethan.zhao@oracle.com
Cc: manish.chopra@qlogic.com, sony.chacko@qlogic.com,
        rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in
 ethtool get_ethtool_stats()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 20:58:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ethan Zhao <ethan.zhao@oracle.com>
Date: Fri, 18 Jul 2014 11:43:29 +0800

> netxen driver has implemented netxen_nic_get_ethtool_stats() interface,
> but it doesn't collect stats.rxdropped in driver, so we will get
> different rx_dropped statistic information while using ifconfig and ethtool.
> this patch fills stats.rxdropped field with data from net core
> with dev_get_stats() just as ixgbe driver did for some of its stats.
> 
> Tested with last netxen 4.0.82
> Compiled with stable 3.15.6
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> Tested-by: Sriharsha Yadagudde <sriharsha.devdas@oracle.com>

ethtool stats are _NOT_ the place to duplicate normal netdev stats,
PERIOD.

The only exception is when you maintainer per-queue instaces of these
stats, and want to export that information to the user.

I'm not applying this, sorry.
