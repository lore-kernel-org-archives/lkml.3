Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaIOMf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:35:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:56569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaIOMfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:35:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,527,1406617200"; 
   d="scan'208";a="603009329"
Date: Mon, 15 Sep 2014 15:35:08 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/6] phy: improved lookup method
Message-ID: <20140915123508.GA16653@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com>
 <5411C0B2.3060505@ti.com>
 <20140912140720.GC30816@xps8300>
 <54130729.5010206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54130729.5010206@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 08:16:01PM +0530, Kishon Vijay Abraham I wrote:
> Assume you have 2 phys in your system..
> static struct phy_lookup usb_lookup = {
> 	.phy_name	= "phy-usb.0",
> 	.dev_id		= "usb.0",
> 	.con_id		= "usb",
> };
> 
> static struct phy_lookup sata_lookup = {
> 	.phy_name	= "sata-usb.1",
> 	.dev_id		= "sata.0",
> 	.con_id		= "sata",
> };
> 
> First you do modprobe phy-usb, the probe of USB PHY driver gets invoked and it
> creates the PHY. The phy-core will find a free id (now it will be 0) and then
> name the phy as phy-usb.0.
> Then with modprobe phy-sata, the phy-core will create phy-sata.1.
> 
> This is an ideal case where the .phy_name in phy_lookup matches.
> 
> Consider if the order is flipped and the user does modprobe phy-sata first. The
> phy_names won't match anymore (the sata phy device name would be "sata-usb.0").

True!

So we can't accept statically created lookups. Which is probable the
best thing to do in any case even if there wasn't this issue.

I think we already talked about this. I know I was going to create the
lookup for twl4030 in twl-core.c instead of the board file at one
point, but forgot about it. I need to do that now.

In any case, I'll fix this by dropping the possibility of creating the
lookups statically. I'll prepare new version of the whole set.


Thanks,

-- 
heikki
