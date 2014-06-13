Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaFMH0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:26:55 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59788 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaFMH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:26:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+hB7scoXdVpwDKnfuXl+hx
Date: Fri, 13 Jun 2014 00:26:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/36] ARM: OMAP2+: gpmc: Allow drivers to query GPMC_CLK
 period
Message-ID: <20140613072645.GN17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-16-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-16-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:59]:
> GPMC_CLK is the external clock output pin that is used for syncronous
> accesses.
> 
> Device drivers need to know the fastest possible GPMC_CLK period in order
> to calculate the most optimal device timings. Add the function
> omap_gpmc_get_clk_period() to allow drivers to get the nearset possible
> (equal to or greater than) GPMC_CLK period given the minimum
> clock period supported by the attached device.
> 
> This is especially needed by the onenand driver as it calculates
> device timings on the fly for various onenand speed grades.

Here too this should probably still be done by the gpmc to driver
glue layer, not by the actual driver that shoud be Linux generic.

Regards,

Tony
