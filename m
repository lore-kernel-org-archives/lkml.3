Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbaCTVLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:11:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51883 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625AbaCTVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:10:59 -0400
Date: Thu, 20 Mar 2014 17:10:57 -0400 (EDT)
Message-Id: <20140320.171057.609753569047907079.davem@davemloft.net>
To: jgunthorpe@obsidianresearch.com
Cc: robh+dt@kernel.org, f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] of_mdio: Allow the DT to specify the phy ID and
 avoid autoprobing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395267324-5788-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1395267324-5788-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1395267324-5788-2-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Mar 2014 14:10:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Wed, 19 Mar 2014 16:15:24 -0600

> This makes the generic of_mdiobus_register parse the DT compatible string for
> the pattern ethernet-phy-idAAAA.BBBB. If present it should be a value that
> matches the phy-id register normally readable through MDIO.
> 
> When the ID is given the phy autoprobing is defeated and the phy is
> created directly.
> 
> This is necessary to support phy's that cannot be autoprobed when
> of_mdiobus_register is called. Specifically, my case has the phy in reset at
> of_mdiobus_register, the reset is only released once the ethernet driver
> starts, before it attaches to the phy.
> 
> Tested on ARM Kirkwood with phy id 0x01410e90 (Marvell 88E1318)
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Also applied to net-next.
