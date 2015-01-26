Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbbAZAB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 19:01:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38038 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAZAB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 19:01:26 -0500
Date: Sun, 25 Jan 2015 16:01:21 -0800 (PST)
Message-Id: <20150125.160121.1332719031463622112.davem@davemloft.net>
To: vivien.didelot@savoirfairelinux.com
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa: set slave MII bus PHY mask
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421799212-2028-2-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1421799212-2028-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1421799212-2028-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Jan 2015 16:01:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date: Tue, 20 Jan 2015 19:13:32 -0500

> When registering a mdio bus, Linux assumes than every port has a PHY and tries
> to scan it. If a switch port has no PHY registered, DSA will fail to register
> the slave MII bus. To fix this, set the slave MII bus PHY mask to the switch
> PHYs mask.
> 
> As an example, if we use a Marvell MV88E6352 (which is a 7-port switch with no
> registered PHYs for port 5 and port 6), with the following declared names:
> 
> 	static struct dsa_chip_data switch_cdata = {
> 		[...]
> 		.port_names[0] = "sw0",
> 		.port_names[1] = "sw1",
> 		.port_names[2] = "sw2",
> 		.port_names[3] = "sw3",
> 		.port_names[4] = "sw4",
> 		.port_names[5] = "cpu",
> 	};
> 
> DSA will fail to create the switch instance. With the PHY mask set for the
> slave MII bus, only the PHY for ports 0-4 will be scanned and the instance will
> be successfully created.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied.
