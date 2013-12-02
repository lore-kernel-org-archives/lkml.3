Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3LBVC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:02:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3LBVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:02:20 -0500
Date: Mon, 02 Dec 2013 16:02:19 -0500 (EST)
Message-Id: <20131202.160219.837472723344445995.davem@davemloft.net>
To: rjw@rjwysocki.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, nsujir@broadcom.com, mchan@broadcom.com
Subject: Re: [PATCH] PCI / tg3: Give up chip reset and carrier loss
 handling if PCI device is not present
From: David Miller <davem@davemloft.net>
In-Reply-To: <7807315.7cU9KldDtM@vostro.rjw.lan>
References: <7807315.7cU9KldDtM@vostro.rjw.lan>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 13:02:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Sun, 01 Dec 2013 02:34:37 +0100

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify tg3_chip_reset() and tg3_close() to check if the PCI network
> adapter device is accessible at all in order to skip poking it or
> trying to handle a carrier loss in vain when that's not the case.
> Introduce a special PCI helper function pci_device_is_present()
> for this purpose.
> 
> Of course, this uncovers the lack of the appropriate RTNL locking
> in tg3_suspend() and tg3_resume(), so add that locking in there
> too.
> 
> These changes prevent tg3 from burning a CPU at 100% load level for
> solid several seconds after the Thunderbolt link is disconnected from
> a Matrox DS1 docking station.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Applied, thanks everyone.
