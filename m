Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3DWRex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:34:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28993 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab3DWRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:34:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rEG64MBqUS44dUZfpRz8A
Date: Tue, 23 Apr 2013 10:34:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP: fix boot sequence
Message-ID: <20130423173442.GF10155@atomide.com>
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130423 06:25]:
> Hi
> 
> There are two public discussions now related to OMAP boot and drivers
> initialization issues:
> "Multiple issues with omap4 panda es in linux next"
>   http://www.spinics.net/lists/linux-omap/msg90241.html
> "[BUG] omap: mfd/regulator: twl/core: init order"
>   http://www.spinics.net/lists/linux-omap/msg89980.html
> 
> In both cases there are pinctrl-single/I2C/MFD/Regulators initailization issue:
> - regulators are not initialized because of twl,
> - twl is not initialized because of I2C,
> - I2C is not initialized because of pinctrl-single,
> - pinctrl-single is initialized at mudule/device init time.
> So, most everything will be shifted at late_initcall time. 
> 
> This may cause boot delay (more over, it can broken initialization of drivers
> which are not ready to use deferred probe mechanism yet, for example DSS).
> 
> Introduced pathes shift I2C and TWL iniialization to module/device init layer
> instead of subsys init layer where initialization dependencies resolved
> indirectly in drivers/Makefile now.
> 
> Grygorii Strashko (2):
>   i2c: omap: convert to module_platform_driver()
>   mfd: twl-core: convert to module_i2c_driver()
> 
>  drivers/i2c/busses/i2c-omap.c |   14 +-------------
>  drivers/mfd/twl-core.c        |   12 +-----------
>  2 files changed, 2 insertions(+), 24 deletions(-)

Thanks, I have few questions:

1. It seems that the real fix to the issues we're seeing
   is to make the broken drivers to support -EPROBE_DEFER?

2. If so, can these be merged later on as clean-up?

3. Can these two patches be merged separately without
   breaking things?

Regards,

Tony
