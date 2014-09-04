Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaIDNv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:51:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35926 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaIDNvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:51:24 -0400
Message-ID: <54086E3D.4000200@ti.com>
Date: Thu, 4 Sep 2014 19:20:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: phy: twl4030-usb: Move code from twl4030_phy_power
 to the runtime PM calls
References: <1409182091-31191-1-git-send-email-tony@atomide.com> <1409182091-31191-4-git-send-email-tony@atomide.com>
In-Reply-To: <1409182091-31191-4-git-send-email-tony@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thursday 28 August 2014 04:58 AM, Tony Lindgren wrote:
> We don't need twl4030_phy_power() any longer now that we have
> the runtime PM calls. Let's get rid of it as it's confusing.
> No functional changes, just move the code and use res instead
> of ret as we are not returning that value.

Now that you are doing pm_runtime_get_sync in twl4030_phy_init, won't it power
on the phy even before initializing it (since runtime_resume will be invoked
even before doing phy_init)?

Even if pm_runtime_get_sync in not done in twl4030_phy_init, phy-core itself
does pm_runtime_get_sync in phy_init().

Thanks
Kishon
