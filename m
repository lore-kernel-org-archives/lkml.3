Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaFMHsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:48:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50372 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaFMHsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:48:45 -0400
Message-ID: <539AACB9.5080105@ti.com>
Date: Fri, 13 Jun 2014 10:48:09 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/36] ARM: OMAP2+: gpmc: Allow drivers to query GPMC_CLK
 period
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-16-git-send-email-rogerq@ti.com> <20140613072645.GN17845@atomide.com>
In-Reply-To: <20140613072645.GN17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 10:26 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140611 01:59]:
>> GPMC_CLK is the external clock output pin that is used for syncronous
>> accesses.
>>
>> Device drivers need to know the fastest possible GPMC_CLK period in order
>> to calculate the most optimal device timings. Add the function
>> omap_gpmc_get_clk_period() to allow drivers to get the nearset possible
>> (equal to or greater than) GPMC_CLK period given the minimum
>> clock period supported by the attached device.
>>
>> This is especially needed by the onenand driver as it calculates
>> device timings on the fly for various onenand speed grades.
> 
> Here too this should probably still be done by the gpmc to driver
> glue layer, not by the actual driver that shoud be Linux generic.

Well, this is only needed by the omap-onenand driver to perform the timing calculations at run-time.
Other option is to model the GPMC_CLK (external) as a clock and request the rate using the clock framework.
But since this and the retime() is only used by 2 OMAP specific drivers, I'm not sure if it is worth the effort.

cheers,
-roger

