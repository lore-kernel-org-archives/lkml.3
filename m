Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3CVOLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:11:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3CVOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:11:41 -0400
Date: Fri, 22 Mar 2013 10:11:39 -0400 (EDT)
Message-Id: <20130322.101139.1942128058226201237.davem@davemloft.net>
To: afleming@freescale.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
References: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:11:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming <afleming@freescale.com>
Date: Wed, 13 Jul 2011 08:52:04 -0500

> The QDisc code does a bunch of locking which is unnecessary if
> you have hardware which handles all of the queueing. Add
> support for this, and skip over all of the queueing code if
> the feature is enabled on a given device, which breaks QDisc
> support on dpaa_eth, and also coopts the FCOE feature bit.
> 
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> Signed-off-by: Ben Collins <ben.c@servergy.com>

Sorry, no.

If we are going to support something like this then there needs to
be full coordination, configuration wise, so that if we enable
a qdisc that the hardware supports we submit it directly, but if
we enable a qdisc the HW does not support, we still use the software
qdisc.

This also means that we need to have a way to determine if the qdisc
configuration exceeds that parametorial limits of the device's HW
capabilities, and fallback to software qdisc in those cases too.
