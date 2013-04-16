Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3DPILI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:11:08 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48219 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3DPILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:11:04 -0400
Message-ID: <516D0790.7090902@iki.fi>
Date: Tue, 16 Apr 2013 11:10:56 +0300
From: Tomi Valkeinen <tomi.valkeinen@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] RTC: rtc-twl: Convert to module_platform_driver() and
 relocate reg_map init
References: <1366098262-20726-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1366098262-20726-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2013-04-16 10:44, Peter Ujfalusi wrote:
> Convert the driver to use module_platform_driver() to register the platform
> driver and relocate the rtc_reg_map initialization to platform driver's
> probe function.
> In this way we can make sure that the twl-core has been already probed since
> the core driver will create the device at the end of it's probe function.
> 
> Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I think there are two distinct things here. The actual fix for the
regmap, and a module_platform_driver cleanup. I would suggest having
them in separate patches.

And even if these are combined, I think the patch subject and
description should talk about fixing the regmap bug. Now it's rather
unclear that an actual bug is being fixed.

 Tomi

