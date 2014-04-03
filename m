Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaDCRag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:30:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45722 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaDCRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:30:32 -0400
Date: Thu, 03 Apr 2014 13:32:03 -0400 (EDT)
Message-Id: <20140403.133203.1056561986987869608.davem@davemloft.net>
To: Max.Nekludov@elster.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        sboyd@codeaurora.org, mjr@cs.wisc.edu, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, trivial@rustcorp.com.au
Subject: Re: ks8851: reset on RX failure and TX timeout
From: David Miller <davem@davemloft.net>
In-Reply-To: <e095559e0b69441eb44fecc7e8639a71@DB3PR02MB202.eurprd02.prod.outlook.com>
References: <b703c70840da4780bc93beed79a8503b@DB3PR02MB202.eurprd02.prod.outlook.com>
	<20140401.181355.1375673242692769955.davem@davemloft.net>
	<e095559e0b69441eb44fecc7e8639a71@DB3PR02MB202.eurprd02.prod.outlook.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 10:30:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nekludov, Max" <Max.Nekludov@elster.com>
Date: Wed, 2 Apr 2014 06:31:23 +0000

> Electromagnetic noise can make device to not send TX interrupts.
> As result outgoing queue will be suspended forever.
> Also EMI can raise RX interrupt with zero value in KS_RXFC register.
> 
> Signed-off-by: Max Nekludov <Max.Nekludov@elster.com>

We have a watchdog facility for TX timeouts, don't reinvent the wheel.

Implement ->ndo_tx_timeout() and set dev->watchdog_timeo appropriately.
