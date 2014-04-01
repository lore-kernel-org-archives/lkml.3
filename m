Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaDAWOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:14:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaDAWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:13:58 -0400
Date: Tue, 01 Apr 2014 18:13:55 -0400 (EDT)
Message-Id: <20140401.181355.1375673242692769955.davem@davemloft.net>
To: Max.Nekludov@elster.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        sboyd@codeaurora.org, mjr@cs.wisc.edu, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, trivial@rustcorp.com.au
Subject: Re: Bug in ks8851.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <b703c70840da4780bc93beed79a8503b@DB3PR02MB202.eurprd02.prod.outlook.com>
References: <9525F3D6E0E9E64DA832F2587811AD6A200C24@USRAL1WVEXC01.elt.lcl>
	<b703c70840da4780bc93beed79a8503b@DB3PR02MB202.eurprd02.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 15:13:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nekludov, Max" <Max.Nekludov@elster.com>
Date: Tue, 1 Apr 2014 15:41:58 +0000

> Reset on RX failure and TX timeout.
> 
> Electromagnetic noice can make device to not send TX interrupts.
> As result outgoing queue will be suspended forever.
> Also EMI can raise RX interrupt with zero value in KS_RXFC register.
> 
> Patch attached.

netdev@vger.kernel.org and the driver maintainer (as listed in
MAINTAINERS) is sufficient for submitting this patch, lists
such as 'trivial' and sending such patches to Linus directly
is not really appropriate.

As per your patch, please do not submit it as an attachment,
as per Documentation/SubmittingPatches, it should be the main
content with the commit message header line being in your
Subject.

Furthermore, in:

+static void ks8851_wdt_work(struct delayed_work *work)
+{
+	struct ks8851_net *ks = container_of(work, struct ks8851_net, wdt_work);
+	mutex_lock(&ks->lock);

You should have an empty line beteen local variable declarations
and where real code starts.


