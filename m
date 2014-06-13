Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFMHTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:19:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46905 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbaFMHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:19:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18J+fkc7HMafeaVU98gNtO6
Date: Fri, 13 Jun 2014 00:19:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/36] mtd: nand: omap: Move gpmc_update_nand_reg to nand
 driver
Message-ID: <20140613071945.GJ17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:58]:
> GPMC and NAND drivers share the same register space but never use the
> same registers. As there is no clear address seperation between the
> registers for GPMC and NAND, we can't easily split it up into 2 regions
> i.e. one for GPMC and other for NAND. Instead, we simply remap the entire
> register space in both the drivers. The NAND driver doesn't re-request
> the region as it is already requested by the GPMC driver (parent).

Oh now, let's not do this. It's best to limit GPMC register access
to the GPMC driver. Even if we need to export few NAND specific
functions from the GPMC driver.

Regards,

Tony
